module SwiftServer
  module Controllers
    module Concerns
      module ContainerHelper
        def list_objects(container, prefix, content_type)
          content_type ||= 'application/json'

          case content_type
          when 'application/json'
            JSON.pretty_generate(container.objects.select { |o| o.key.start_with?(prefix) }
              .each_with_object([]) do |obj, res|
              res << {
                content_type: obj.content_type,
                bytes: obj.size,
                last_modified: obj.updated_at,
                hash: obj.md5
              }
            end)
          when 'text/plain'
            container.objects.select { |o| o.key.start_with?(prefix) }.map(&:key).join("\n")
          end
        end
      end
    end
  end
end
