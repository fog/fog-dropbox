require 'spec_helper'

describe "Fog::Storage::Dropbox::Directories" do

  after(:all) do
    @dropbox_client = DropboxClient.new(ENV['DROPBOX_OAUTH2_ACCESS_TOKEN'])
    VCR.use_cassette("fog/storage/dropbox/directories/get") do
      @dropbox_client.file_delete "/TEST_DIRECTORY"
    end
  end

  describe "#all" do

    let(:client) { Fog::Storage::Dropbox.new(:dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }
    let(:subject) { client.directories.all }

    it "should not throw error for root listing" do
      VCR.use_cassette("fog/storage/dropbox/directories/all") do
        expect(subject).to be_a(Fog::Storage::Dropbox::Directories)
      end
    end

  end

  describe "#get" do

    let(:dropbox_client) { DropboxClient.new(ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }
    let(:client) { Fog::Storage::Dropbox.new(:dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }
    let(:a_directory) { "/TEST_DIRECTORY" } # If you change this, it will upset VCR
    let(:not_a_directory) { "/THIS_SHOULD_MATCH_NO_DIRECTORY_IN_YOUR_DROPBOX" } # If you change this, it will upset VCR

    it "should raise error for missing directory" do
      VCR.use_cassette("fog/storage/dropbox/directories/get") do
        expect( client.directories.get(not_a_directory) ).to eq(nil)
      end
    end

    it "should get directory" do
      VCR.use_cassette("fog/storage/dropbox/directories/get") do
        dropbox_client.file_create_folder(a_directory) # create a directory to test
        directory = client.directories.get(a_directory)
        expect(directory).to be_a(Fog::Storage::Dropbox::Directory)
        expect(directory.key).to eq(a_directory)
      end
    end

  end

end
