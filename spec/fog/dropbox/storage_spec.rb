require 'spec_helper'

describe "Fog::Storage::Dropbox" do
  describe "#initialize" do

    it "should initialize without error" do
      expect(Fog::Storage::Dropbox.new(:dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN'])).to be_a(Fog::Storage::Dropbox::Real)
    end

    it "should raise error when missing required params" do
      expect{ Fog::Storage::Dropbox.new() }.to raise_error
    end

  end
end
