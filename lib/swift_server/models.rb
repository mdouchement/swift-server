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

    def load(filename)
      return unless File.file?(filename)
      payload = File.read(filename)
      return if payload.empty?
      JSON.parse(File.read(filename)).each do |k, v|
        v.each { |relation| database.relations[k.to_sym].insert(relation.deep_symbolize_keys) }
      end
    end

    def backup(filename)
      File.open(filename, 'w') do |f|
        f << JSON.pretty_generate(
          {}.tap do |payload|
            database.gateways[:default].connection.data.each do |k, v|
              payload[k] = v.data
            end
          end
        )
      end
    end
  end
end
