require 'fog/core/collection'
require 'fog/dropbox/models/storage/file'

module Fog
  module Storage
    class Dropbox
      class Files < Fog::Collection

        attribute :directory

        model Fog::Storage::Dropbox::File

        def get(key, options = {}, &block)
          requires :directory

          metadata = service.client.metadata(key)

          new(metadata)
        rescue DropboxError
          nil
        end

        def head(key, options = {})
          requires :directory

          metadata = service.client.metadata(key)

          new(metadata)
        rescue DropboxError
          nil
        end

        def new(attributes = {})
          requires :directory
		  attributes['path'] ||= attributes[:key]
          attributes[:name] = attributes['path'].split('/').last
          super({ :directory => directory }.merge(attributes))
        end
      end
    end
  end
end
