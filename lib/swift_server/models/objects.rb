module SwiftServer
  module Models
    class Object < ROM::Struct
      def container
        Models::container.restrict(id: container_id).first
      end

      def manifest
        Models::manifest.restrict(id: manifest_id).first
      end

      def update(params)
        params[:updated_at] = Time.now
        params[:container_id] = params.delete(:container).id if params[:container].present?
        params[:manifest_id] = params.delete(:manifest).id if params[:manifest].present?
        Models::object.restrict(id: id).dataset.data.first.merge!(params) # IDK how updates work with ROM, but this seems to work at least
      end

      def destroy
        File.unlink(file_path) if file_path.present? && File.file?(file_path) # Remove the underlying file
        Models::object.dataset.data.reject! { |object| object[:id] == id } # IDK how deletes work with ROM, but this seems to work at least
      end
    end

    class Objects < ROM::Relation[:memory]
      auto_struct true
      struct_namespace Models

      UUID = Types::String.default { SecureRandom.uuid }
      NOW = Types::Time.default { Time.now }
      schema(:objects) do
        attribute :id, UUID
        attribute :created_at, NOW
        attribute :updated_at, NOW
        attribute :uri, Types::String
        attribute :key, Types::String.optional
        attribute :size, Types::Integer.optional
        attribute :content_type, Types::String.optional
        attribute :file_path, Types::String.optional
        attribute :md5, Types::String.optional

        primary_key :id
        attribute :container_id, Types::ForeignKey(:containers, Types::String)
        attribute :manifest_id, Types::ForeignKey(:manifests, Types::String)

        associations do
          belongs_to :containers, as: :container
          belongs_to :manifests, as: :manifest
        end
      end

      def find_by_id(id)
        find { |object| object.id == id }
      end

      def find_by_uri(uri)
        find { |object| object.uri == uri }
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
        Models::object.command(:create, result: :one).call(params)
      end

      # https://github.com/dry-rb/dry-validation
      # validates_presence_of :uri
      # validates_uniqueness_of :uri
    end
  end
end
