require 'fog/core/model'
require 'fog/dropbox/models/storage/files'

module Fog
  module Storage
    class Dropbox
      class Directory < Fog::Model
        identity  :key,           :aliases => ['path']
        
        attribute :size
        attribute :rev
        attribute :bytes
        attribute :last_modified, :aliases => ['client_mtime']

        def destroy
          requires :key
          service.client.file_delete(key)
          true
        rescue DropboxError
          false
        end

        def files
          @files ||= begin
            Fog::Storage::Dropbox::Files.new(
              :directory    => self,
              :service   => service
            )
          end
        end

        def save
          requires :key
          service.client.file_create_folder(key)
          true
        end
      end
    end
  end
end
