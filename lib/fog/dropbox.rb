require "fog/core"
require "fog/dropbox/version"

module Fog

  module Storage
    autoload :Dropbox, "fog/dropbox/storage"
  end

  module Dropbox

    extend Fog::Provider

    service(:storage,    'Storage')

  end
end
