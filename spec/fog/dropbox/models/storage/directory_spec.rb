require 'spec_helper'
require 'dropbox_sdk'

describe "Fog::Storage::Dropbox::Directory" do

  let(:dropbox_client) { DropboxClient.new(ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }
  let(:client) { Fog::Storage::Dropbox.new(:dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }


  describe "#save" do

    it "should allow creating new directories" do
      VCR.use_cassette("fog/storage/dropbox/directory/save") do
        directory = "/Save-then-Delete"
        dropbox_client.file_delete(directory) rescue nil # An exception here is OK
        subject = client.directories.new(key: directory).save
        expect(subject).to be_truthy
        expect(dropbox_client.metadata(directory)).to be_truthy
        dropbox_client.file_delete(directory)
      end
    end

  end

  describe "#files" do

    it "should handle missing directory" do
      VCR.use_cassette("fog/storage/dropbox/directory/files") do
        expect( client.directories.get("/The-Light-of-Nowheretown") ).to eq(nil)
      end
    end

    it "should get directory files" do
      VCR.use_cassette("fog/storage/dropbox/directory/files") do
        album = "/Mastermind"
        singles = ["The-Devil-Is-a-Lie", "War-Ready", "Thug-Cry"]
        singles.each do |single|
          dropbox_client.put_file([album, single].join('/'), "Bellaire Rose", true) # this last `true` means overwrite
        end
        directory = client.directories.get(album)
        expect(directory).to be_a(Fog::Storage::Dropbox::Directory)
        expect(directory.key).to eq(album)
        expect(directory.files.length).to eq(singles.length)
        expect(directory.files.first).to be_a(Fog::Storage::Dropbox::File)
        expect(directory.files.map{|file| file.name }).to include(*singles)
      end
    end

  end

  describe "#destroy" do

    it "should allow creating new directories" do
      VCR.use_cassette("fog/storage/dropbox/directory/destroy") do
        directory = "/Just-to-Delete"
        dropbox_client.file_create_folder(directory) rescue nil # An exception here is OK
        subject = client.directories.new(key: directory).destroy
        expect(subject).to be_truthy
        expect(dropbox_client.metadata(directory)['is_deleted']).to be_truthy
      end
    end

  end

end
