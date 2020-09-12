module SwiftServer
  module Models
    class Manifest < ROM::Struct
      def container
        Models::container.restrict(manifest_id: id)
      end

      def objects
        Models::object.restrict(manifest_id: id)
      end

      def update(params)
         # IDK how updates work with ROM (no clear documentation), but this seems to work at least
        params[:updated_at] = Time.now
        params[:container_id] = params.delete(:container).id if params[:container].present?
        params.delete(:objects).each do |object|
          Models::object.restrict(id: object.id).dataset.data.first[manifest_id: id]
        end if params[:objects].present?
        Models::manifest.restrict(id: id).dataset.data.first.merge!(params)
      end

      def destroy
        manifest = Models::manifest.restrict(id: id)
        manifest.objects.each { |object| object.destroy }
        Models::manifest.dataset.data.reject! { |manifest| manifest[:id] == id } # IDK how deletes work with ROM, but this seems to work at least
      end
    end

    class Manifests < ROM::Relation[:memory]
      auto_struct(true)
      struct_namespace Models

      UUID = Types::String.default { SecureRandom.uuid }
      NOW = Types::Time.default { Time.now }
      schema(:manifests) do
        attribute :id, UUID
        attribute :created_at, NOW
        attribute :updated_at, NOW
        attribute :uri, Types::String
        attribute :key, Types::String.optional
        attribute :content_type, Types::String.optional
        attribute :size, Types::Integer.optional
        attribute :md5, Types::String.optional

        primary_key :id
        attribute :container_id, Types::ForeignKey(:containers, Types::String)

        associations do
          belongs_to :containers, as: :manifest
          has_many :objects, combine_key: :manifest_id
        end
      end

      def find_by_id(id)
        find { |object| object.id == id }
      end

      def find_by_uri(uri)
        find { |manifest| manifest.uri == uri }
      end

      def find_or_create_by_uri(uri)
        find_by_uri(uri) || create(uri)
      end

      def create(uri)
        params = schema.attributes.each_with_object({}) do |attribute, params|
          next if attribute.name == :id
          params[attribute.name] = nil
        end
        params[:uri] = uri
        Models::manifest.command(:create, result: :one).call(params)
      end

      def update(params = {})
        command(:update).call(params)
      end

      # validates_presence_of :uri
      # validates_uniqueness_of :uri
    end
  end
end
