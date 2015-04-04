# Fog::Dropbox

Fog's great! Let's support Dropbox.

## Storage

### Application Setup

You're going to need to setup a [Dropbox Application](https://www.dropbox.com/developers/apps).
- Select `Dropbox API App` (not Drop-ins App).
- Select `Files and datastores`
- Select can be limited to its own folder (unless yours can't, but it probably can).

Click `Generate Access Token` to create an OAuth2 access token for your account. Grab this.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fog-dropbox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-dropbox

## Usage

```ruby
fog_client = Fog::Storage::Dropbox.new(:dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN'])

# Read directory
folder = "/folder"
filename = "file"
key = [folder, filename].join('/')
directory = fog_client.directories.get(folder)
puts directory.inspect

# Read file
file = directory.files.get(key)
puts file.inspect
puts file.body

# Get file share link
puts file.url()

# Write string
file.body = "New Content"
file.save()

# Write large file
large_file = Tempfile.new("fog-dropbox-multipart")
6.times { large_file.write("x" * (1024**2)) } # 6 MB file
large_file.rewind
file.body = large_file
file.save()

# Delete
file.destroy()
```

## Contributing

1. Fork it ( https://github.com/zshannon/fog-dropbox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
