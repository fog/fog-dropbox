require 'fog/core/collection'
require 'fog/dropbox/models/storage/directory'

module Fog
  module Storage
    class Dropbox
      class Directories < Fog::Collection
        model Fog::Storage::Dropbox::Directory

        def all
          data = service.client.metadata('/')
          load(data['contents'])
        end

        def get(key, options = {})
          data = service.client.metadata(key)
          directory = new(data)
          directory.files.load(data['contents'])
          directory
        rescue DropboxError
          nil
        end
      end
    end
  end
end
