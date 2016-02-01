module SwiftServer
  module Controllers
    module Concerns
      module ObjectHelper
        def persist(io)
          File.open(file_path, 'w') do |file|
            file << io.read
          end
        end

        def copy_file(copy_object)
          FileUtils.cp(copy_object.file_path, file_path)
        end

        def create_manifest(manifest)
          Dir.entries(File.join('storage', json_params[:x_object_manifest])).sort.each do |file|
            next if %w(. ..).include? file
            Models::Object.find_by_uri(json_params[:x_object_manifest] + file).update_attributes(manifest: manifest)
          end
        end

        def manifest_file(manifest)
          file = Tempfile.new(manifest.created_at.to_s)
          manifest.objects.each do |o|
            file << File.read(o.file_path)
          end
          yield(file)
          file.close
          file.unlink
        end

        def key
          @key ||= json_params[:uri].split('/')[1..-1].join('/')
        end

        def container
          @container ||= Models::Container.find_by_name(container_name)
        end

        def container_name
          @container_name ||= json_params[:uri].split('/').first
        end

        def copied_from_key
          @copied_from_key ||= req_headers[:x_copy_from].split('/')[1..-1].join('/')
        end

        def copied_from_container
          @copied_from_container ||= Models::Container.find_by_name(container_name)
        end

        def copied_from_container_name
          @copied_from_container_name ||= req_headers[:x_copy_from].split('/').first
        end

        private

        def file_path
          "#{path}/#{json_params[:uri].split('/').last}"
        end

        def path
          File.join('storage', *json_params[:uri].split('/')[0..-2]).tap do |p|
            FileUtils.mkdir_p p
          end
        end

        def copied_file_path
          "#{copied_path}/#{req_headers[:x_copy_from].split('/').last}"
        end

        def copied_path
          File.join('storage', *req_headers[:x_copy_from].split('/')[0..-2]).tap do |p|
            FileUtils.mkdir_p p
          end
        end
      end
    end
  end
end
