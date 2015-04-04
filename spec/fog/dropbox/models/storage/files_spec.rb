require 'spec_helper'

describe "Fog::Storage::Dropbox::Files" do

  before(:all) do
    @dropbox_client = DropboxClient.new(ENV['DROPBOX_OAUTH2_ACCESS_TOKEN'])
    VCR.use_cassette("fog/storage/dropbox/files") do
      @path = "/Mastermind"
      @singles = ["The-Devil-Is-a-Lie", "War-Ready", "Thug-Cry"]
      @singles.each do |single|
        @dropbox_client.put_file([@path, single].join('/'), "Bellaire Rose", true) # this last `true` means overwrite
      end
    end
  end

  after(:all) do
    VCR.use_cassette("fog/storage/dropbox/files") do
      @dropbox_client.file_delete @path
    end
  end

  let(:client) { Fog::Storage::Dropbox.new(:dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']) }

  describe "#all" do

    it "should find all the files in a directory" do
      VCR.use_cassette("fog/storage/dropbox/files") do
        directory = client.directories.get(@path)
        subject = directory.files
        expect(subject).to be_truthy
        expect(subject).to be_a(Fog::Storage::Dropbox::Files)
        expect(subject.count).to eq(@singles.count)
        expect(subject.first).to be_a(Fog::Storage::Dropbox::File)
        expect(subject.map{|file| file.name }).to include(*@singles)
      end
    end

  end

  describe "#get" do

    it "should find the correct file" do
      VCR.use_cassette("fog/storage/dropbox/files") do
        directory = client.directories.get(@path)
        key = [@path, @singles.first].join('/')
        subject = directory.files.get(key)
        expect(subject).to be_truthy
        expect(subject).to be_a(Fog::Storage::Dropbox::File)
        expect(subject.key).to eq(key)
        expect(subject.name).to eq(@singles.first)
      end
    end

    it "should handle non-existant file with nil" do
      VCR.use_cassette("fog/storage/dropbox/files") do
        directory = client.directories.get(@path)
        key = [@path, "not-a-rick-ross-single"].join('/')
        subject = directory.files.get(key)
        expect(subject).to be_nil
      end
    end

  end

  describe "#head" do

    it "should find the correct file" do
      VCR.use_cassette("fog/storage/dropbox/files") do
        directory = client.directories.get(@path)
        key = [@path, @singles.first].join('/')
        subject = directory.files.head(key)
        expect(subject).to be_truthy
        expect(subject).to be_a(Fog::Storage::Dropbox::File)
        expect(subject.key).to eq(key)
        expect(subject.name).to eq(@singles.first)
      end
    end

    it "should handle non-existant file with nil" do
      VCR.use_cassette("fog/storage/dropbox/files") do
        directory = client.directories.get(@path)
        key = [@path, "not-a-rick-ross-single"].join('/')
        subject = directory.files.head(key)
        expect(subject).to be_nil
      end
    end

  end

end
