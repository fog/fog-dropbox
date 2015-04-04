module Dropbox # deviates from other bin stuff to accomodate gem
  class << self
    def class_for(key)
      case key
        when :storage
          Fog::Storage::Dropbox
        else
          raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
                      when :storage
                        Fog::Logger.warning("Dropbox[:storage] is not recommended, use Storage[:dropbox] for portability")
                        Fog::Storage.new(:provider => 'Dropbox')
                      else
                        raise ArgumentError, "Unrecognized service: #{key.inspect}"
                    end
      end
      @@connections[service]
    end

    def account
      @@connections[:compute].account
    end

    def services
      Fog::Dropbox.services
    end

    # based off of virtual_box.rb
    def available?
      # Make sure the gem we use is enabled.
      availability = if Gem::Specification.respond_to?(:find_all_by_name)
                       !Gem::Specification.find_all_by_name('dropbox-sdk').empty? # newest rubygems
                     else
                       !Gem.source_index.find_name('dropbox-sdk').empty? # legacy
                     end
      # Then make sure we have all of the requirements
      for service in services
        begin
          service = self.class_for(service)
          availability &&= service.requirements.all? { |requirement| Fog.credentials.include?(requirement) }
        rescue ArgumentError => e
          Fog::Logger.warning(e.message)
          availability = false
        rescue => e
          availability = false
        end
      end

      if availability
        for service in services
          for collection in self.class_for(service).collections
            unless self.respond_to?(collection)
              self.class_eval <<-EOS, __FILE__, __LINE__
                def self.#{collection}
                  self[:#{service}].#{collection}
                end
              EOS
            end
          end
        end
      end
      availability
    end
  end
end
