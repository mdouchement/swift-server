class ContainersController < ApplicationController
  def index
    app.status 200
    Container.all.each_with_object([]) do |container, res|
      res << {
        name: container.name,
        last_updated: container.updated_at
      }
    end.to_json
  end

  def show
    container = Container.find_by_name(json_params[:container])

    if container
      case json_params[:method]
      when :head
      when :get
        container.sw_objects.each_with_object([]) do |obj, res|
          res << {
            content_type: obj.content_type,
            bytes: obj.size,
            last_modified: obj.updated_at,
            hash: obj.md5
          }
        end.to_json
      end
      resp_headers['X-Container-Object-Count'] = container.sw_objects.count
      resp_headers['X-Timestamp'] = container.created_at.to_i
      resp_headers['Date'] = Time.now
      app.status 200
    else
      app.status 404
    end
  end

  def update
    container = Container.find_or_create_by_name(json_params[:container])
    resp_headers['X-Timestamp'] = container.created_at.to_i
    resp_headers['Date'] = Time.now
    app.status 201
  end

  def destroy
    container = Container.find_by_name(json_params[:container])

    if container
      if container.sw_objects.count == 0
        app.status 204
        container.destroy!
      else
        app.status 409
      end
    else
      app.status 404
    end
  end
end
