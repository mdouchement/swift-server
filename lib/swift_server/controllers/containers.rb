module SwiftServer
  module Controllers
    class Containers < ApplicationController
      include Concerns::ContainerHelper

      def index
        app.status 200
        case req_headers[:accept]
        when 'application/json'
          JSON.pretty_generate(Models::container.all.each_with_object([]) do |container, res|
            res << {
              name: container.name,
              last_updated: container.updated_at
            }
          end)
        when 'text/plain'
          Models::container.all.map(&:name).join("\n")
        end
      end

      def show
        container = Models::container.find_by_name(json_params[:container])

        if container
          app.status 200
          safe_append_header('Date', Time.now)
          safe_append_header('X-Timestamp', container.created_at.to_i)
          safe_append_header('X-Container-Object-Count', container.objects.count)
          case json_params[:method]
          when :head
          when :get
            list_objects(container, app.params[:prefix].to_s, req_headers[:accept])
          end
        else
          app.status 404
        end
      end

      def update
        container = Models::container.find_or_create_by_name(json_params[:container])
        safe_append_header('X-Timestamp', container.created_at.to_i)
        safe_append_header('Date', Time.now)
        app.status 201
      end

      def destroy
        container = Models::container.find_by_name(json_params[:container])

        if container
          if container.objects.count == 0
            app.status 204
            container.destroy
          else
            app.status 409
          end
        else
          app.status 404
        end
      end
    end
  end
end
