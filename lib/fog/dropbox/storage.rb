require 'dropbox_sdk'

module Fog
  module Storage
    class Dropbox < Fog::Service
      requires :dropbox_oauth2_access_token
      recognizes :host, :port, :scheme, :persistent, :path_style

      model_path 'fog/dropbox/models/storage'
      collection  :directories
      model       :directory
      collection  :files
      model       :file

      class Real

        # Initialize connection to Dropbox
        #
        # ==== Notes
        # options parameter must include a value for :dropbox_oauth2_access_token
        # in order to create a connection
        #
        # ==== Examples
        #   dropbox_storage = Storage.new(
        #     :dropbox_oauth2_access_token => ENV['DROPBOX_OAUTH2_ACCESS_TOKEN']
        #   )
        #
        # ==== Returns
        # * Storage object with connection to Dropbox.
        def initialize(options={})

          @dropbox_oauth2_access_token = options[:dropbox_oauth2_access_token]
          @dropbox_client = DropboxClient.new(@dropbox_oauth2_access_token)

        end

        def client
          @dropbox_client
        end

      end
    end
  end
end
