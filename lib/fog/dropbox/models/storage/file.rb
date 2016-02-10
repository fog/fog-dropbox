require 'fog/core/model'

module Fog
  module Storage
    class Dropbox
      class File < Fog::Model
        identity  :key,                 :aliases => 'path'

        attribute :name
        attribute :rev,                 :aliases => 'rev'
        attribute :content_encoding,    :aliases => 'Content-Encoding'
        attribute :content_length,      :aliases => ['size']
        attribute :content_type,        :aliases => 'mime_type'
        attribute :last_modified,       :aliases => ['client_mtime']

        def body
          attributes[:body] ||= if last_modified && (file = collection.get(identity))
            service.client.get_file(key)
          else
            ''
          end
        end

        def body=(new_body)
          attributes[:body] = new_body
        end

        def directory
          @directory
        end

        def destroy
          requires :key
          begin
            service.client.file_delete(key)
          rescue DropboxError
          end
          true
        end

        def save(options = {})
          requires :body, :directory, :key
          if body.is_a? String
            service.client.put_file(key, body, true) # true means overwrite
          else
            local_file_size = Fog::Storage.get_body_size(body)
            uploader = service.client.get_chunked_uploader(body, local_file_size)
            retries = 0
            chunk_size = 4 * (1024**2) # 4 MB
            while uploader.offset < uploader.total_size
                begin
                    uploader.upload(chunk_size)
                rescue DropboxError => e
                    if retries > 10
                        break
                    end
                    retries += 1
                end
            end
            uploader.finish(key, true) # true means overwrite
          end
        end
	
        def public_url
          self.url
        end

        def url()
          requires :key
          share = service.client.shares(key)
          url = share['url']
          r = Net::HTTP.get_response(URI.parse(url))
          if r.code == "302"
            url = r.header['location']
          end
          CGI.unescape url.gsub("dl=0", "dl=1")
        end

      end
    end
  end
end
