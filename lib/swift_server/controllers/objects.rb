module SwiftServer
  module Controllers
    class Objects < ApplicationController
      include Concerns::ObjectHelper
      include Concerns::CleanerManager

      def show
        object = Models::object.find_by_uri(json_params[:uri])
        manifest = Models::manifest.find_by_uri(json_params[:uri])

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
            manifest_file(manifest) do |file|
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
        if (copied_object = Models::object.find_by_uri(req_headers[:x_copy_from]))
          object_creation do
            copy_file(copied_object)
          end
        elsif (copied_manifest = Models::manifest.find_by_uri(req_headers[:x_copy_from]))
          manifest_creation do |manifest|
            manifest.update(objects: copied_manifest.objects,
                            md5: copied_manifest.md5,
                            size: copied_manifest.size,
                            content_type: copied_manifest.content_type)
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
        object = Models::object.find_by_uri(json_params[:uri]) || Models::manifest.find_by_uri(json_params[:uri])

        if object
          app.status 204
          object.destroy
          remove_empty_directories
        else
          app.status 404
        end
      end

      private

      def object_creation
        object = Models::object.find_or_create_by_uri(json_params[:uri])

        yield
        file_path = "storage/#{json_params[:uri]}"

        checksum = Digest::MD5.file(file_path).hexdigest
        object.update(
          container: container,
          key: key,
          content_type: req_headers[:content_type] || 'application/octet-stream',
          file_path: file_path,
          size: File.size(file_path),
          md5: checksum
        )

        safe_append_header('Etag', checksum)
        safe_append_header('X-Timestamp', object.created_at.to_i)
        safe_append_header('Date', Time.now.getlocal)
        app.status 201
      end

      def manifest_creation
        manifest = Models::manifest.find_or_create_by_uri(json_params[:uri])
        manifest.update(container: container, key: key, content_type: req_headers[:content_type])

        yield(manifest)

        if manifest.size.nil? || manifest.size.zero? # Only when it is not a copied manifest
          manifest.update(size: manifest.objects.sum(&:size),
                          content_type: manifest.objects.last.content_type,
                          md5: SecureRandom.hex)
        end

        safe_append_header('X-Timestamp', manifest.created_at.to_i)
        safe_append_header('Date', Time.now.getlocal)
        app.status 201
      end
    end
  end
end
