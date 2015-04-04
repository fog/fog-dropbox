require 'spec_helper'
require 'tempfile'
require 'open-uri'

describe "Fog::Storage::Dropbox::File" do

  let(:dropbox_client) { DropboxClient.new(ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }
  let(:client) { Fog::Storage::Dropbox.new(:dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }

  describe "#body" do

    it "should read file" do
      VCR.use_cassette("fog/storage/dropbox/directory/file/string") do
        folder = "/FileTests"
        file = "Testfile"
        key = [folder, file].join('/')
        file_content = "Bellaire Rose"
        dropbox_client.put_file(key, file_content, true) # this last `true` means overwrite
        directory = client.directories.get(folder)
        file = directory.files.get(key)
        expect(file.body).to eq(file_content)
      end
    end

    it "should write file" do
      VCR.use_cassette("fog/storage/dropbox/directory/file/small_file") do
        folder = "/FileTests"
        file = "Testfile"
        key = [folder, file].join('/')
        file_content = "Bellaire Rose"
        directory = client.directories.get(folder)
        file = directory.files.get(key)
        file.body = file_content
        file.save
        dropbox_file_content = dropbox_client.get_file(key)
        expect(dropbox_file_content).to eq(file_content)
      end
    end

    it "should write large file" do
      VCR.use_cassette("fog/storage/dropbox/directory/file/large_file") do
        folder = "/FileTests"
        file = "Testfile"
        key = [folder, file].join('/')
        directory = client.directories.get(folder)
        large_file = Tempfile.new("fog-dropbox-multipart")
        6.times { large_file.write("x" * (1024**2)) } # 6 MB file
        large_file.rewind
        file = directory.files.create(
          'path' => key,
          :key => key,
          :body => large_file
        )
        expect(file).to be_truthy
        large_file_sha256 = Digest::SHA256.file(large_file).hexdigest
        large_file.close
        dropbox_file = Tempfile.new("fog-dropbox-multipart--retrieved")
        dropbox_file.write(dropbox_client.get_file(key))
        dropbox_file_sha256 = Digest::SHA256.file(dropbox_file).hexdigest
        dropbox_file.close
        expect(large_file_sha256).to eq(dropbox_file_sha256)
      end
    end

  end

  describe "#url" do

    it "should get a valid share url" do
      VCR.use_cassette("fog/storage/dropbox/directory/file/string") do
        folder = "/FileTests"
        file = "Testfile"
        key = [folder, file].join('/')
        file_content = "Bellaire Rose"
        dropbox_client.put_file(key, file_content, true) # this last `true` means overwrite
        directory = client.directories.get(folder)
        file = directory.files.get(key)
        share_url = file.url()
        expect(share_url =~ URI::regexp).to be_truthy
        retrieved_content = open(share_url).read
        expect(retrieved_content).to eq(file_content)
      end
    end

  end

  describe "#destroy" do

    it "should delete file" do
      VCR.use_cassette("fog/storage/dropbox/directory/file/destroy") do
        folder = "/FileTests"
        file = "Testfile"
        key = [folder, file].join('/')
        file_content = "Bellaire Rose"
        dropbox_client.put_file(key, file_content, true) # this last `true` means overwrite
        directory = client.directories.get(folder)
        file = directory.files.get(key)
        expect(file.destroy).to be_truthy
        metadata = dropbox_client.metadata(key)
        expect(metadata['is_deleted']).to be_truthy
      end
    end

  end

end
