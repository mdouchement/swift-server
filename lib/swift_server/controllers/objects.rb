module SwiftServer
  module Controllers
    class Objects < ApplicationController
      include Concerns::ObjectHelper

      def show
        object = Models::Object.find_by_uri(json_params[:uri])
        manifest = Models::Manifest.find_by_uri(json_params[:uri])

        if object
          app.status 200
          case json_params[:method]
          when :head
            safe_append_header('Content-Type', object.content_type)
            safe_append_header('Content-Length', object.size)
            safe_append_header('X-Timestamp', object.created_at.to_i)
            safe_append_header('ETag', object.hash)
            safe_append_header('Date', Time.now.getlocal)
          when :get
            app.send_file object.file_path,
              type: object.content_type,
              filename: object.key.split('/').last
          end
        elsif manifest
          app.status 200
          case json_params[:method]
          when :head
            safe_append_header('Content-Type', manifest.content_type)
            safe_append_header('Content-Length', manifest.size)
            safe_append_header('X-Timestamp', manifest.created_at.to_i)
            safe_append_header('ETag', manifest.hash)
            safe_append_header('Date', Time.now.getlocal)
          when :get
            manifest_file(smanifest) do |file|
              app.send_file file,
                type: manifest.content_type,
                filename: manifest.key.split('/').last
            end
          end
        else
          app.status 404
        end
      end

      def update
        object_creation do
          persist(app.request.body)
        end
      end

      def copy
        if copied_object = Models::Object.find_by_uri(req_headers[:x_copy_from])
          object_creation do
            copy_file(copied_object)
          end
        elsif copied_manifest = Models::Manifest.find_by_uri(req_headers[:x_copy_from])
          manifest_creation do |manifest|
            manifest.objects = copied_manifest.objects
          end
        else
          app.status 404
        end
      end

      def manifest
        manifest_creation do |manifest|
          create_manifest(manifest)
        end
      end

      def destroy
        object = Models::Object.find_by_uri(json_params[:uri]) || Models::Manifest.find_by_uri(json_params[:uri])

        if object
          app.status 204
          object.destroy
        else
          app.status 404
        end
      end

      private

      def object_creation
        object = Models::Object.find_or_create_by_uri(json_params[:uri])

        yield
        file_path = "storage/#{json_params[:uri]}"

        object.update_attributes(
          container: container,
          key: key,
          content_type: req_headers[:content_type],
          file_path: file_path,
          size: File.size(file_path),
          md5: Digest::MD5.file(file_path).hexdigest
        )

        safe_append_header('X-Timestamp', object.created_at.to_i)
        safe_append_header('Date', Time.now.getlocal)
        app.status 201
      end

      def manifest_creation
        manifest = Models::Manifest.find_or_create_by_uri(json_params[:uri])
        manifest.update_attributes(container: container, key: key, content_type: req_headers[:content_type])

        yield(manifest)

        safe_append_header('X-Timestamp', manifest.created_at.to_i)
        safe_append_header('Date', Time.now.getlocal)
        app.status 201
      end
    end
  end
end
