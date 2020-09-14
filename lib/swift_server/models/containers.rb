module SwiftServer
  module Models
    class Container < ROM::Struct
      def objects
        Models::object.restrict(container_id: id)
      end

      def manifests
        Models::manifest.restrict(container_id: id)
      end

      def destroy
        Models::container.restrict(id: id).objects.each { |object| object.destroy }
        Models::container.dataset.data.reject! { |container| container[:id] == id } # IDK how deletes work with ROM, but this seems to work at least
      end
    end

    class Containers < ROM::Relation[:memory]
      auto_struct true
      struct_namespace Models

      UUID = Types::String.default { SecureRandom.uuid }
      NOW = Types::Time.default { Time.now }
      schema(:containers) do
        attribute :id, UUID
        attribute :created_at, NOW
        attribute :updated_at, NOW
        attribute :name, Types::String

        primary_key :id

        associations do
          has_many :objects, combine_key: :container_id
          has_many :manifests, combine_key: :container_id
        end
      end


      def find_by_name(name)
        find { |container| container.name == name }
      end

      def find_or_create_by_name(name)
        find_by_name(name) || create(name)
      end

      def create(name)
        Models::container.command(:create, result: :one).call(name: name)
      end

      # https://github.com/dry-rb/dry-validation
      # validates_presence_of :name
    end
  end
end
