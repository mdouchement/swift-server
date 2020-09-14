require 'rom'

module SwiftServer
  module Models
    module_function

    def container
      database.relations[:containers]
    end

    def object
      database.relations[:objects]
    end

    def manifest
      database.relations[:manifests]
    end

    def database
      @database ||= ROM.container(:memory) do |config|
        require 'swift_server/models/objects'
        require 'swift_server/models/manifests'
        require 'swift_server/models/containers'

        config.register_relation(Models::Containers)
        config.register_relation(Models::Objects)
        config.register_relation(Models::Manifests)
      end
    end
  end
end
