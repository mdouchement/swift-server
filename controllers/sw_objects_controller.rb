class SwObjectsController < ApplicationController
  include SwObjectHelper

  def show
    sw_object = SwObject.find_by_uri(json_params[:uri])
    sw_manifest = SwManifest.find_by_uri(json_params[:uri])

    if sw_object
      app.status 200
      case json_params[:method]
      when :head
        safe_append_header('Content-Type', sw_object.content_type)
        safe_append_header('Content-Length', sw_object.size)
        safe_append_header('X-Timestamp', sw_object.created_at.to_i)
        safe_append_header('ETag', sw_object.hash)
        safe_append_header('Date', Time.now)
      when :get
        app.send_file sw_object.file_path,
          type: sw_object.content_type,
          filename: sw_object.key.split('/').last
      end
    elsif sw_manifest
      app.status 200
      case json_params[:method]
      when :head
        safe_append_header('Content-Type', sw_manifest.content_type)
        safe_append_header('Content-Length', sw_manifest.size)
        safe_append_header('X-Timestamp', sw_manifest.created_at.to_i)
        safe_append_header('ETag', sw_manifest.hash)
        safe_append_header('Date', Time.now)
      when :get
        manifest_file(sw_manifest) do |file|
          app.send_file file,
            type: sw_manifest.content_type,
            filename: sw_manifest.key.split('/').last
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
    if copied_object = SwObject.find_by_uri(req_headers[:x_copy_from])
      object_creation do
        copy_file(copied_object)
      end
    elsif copied_manifest = SwManifest.find_by_uri(req_headers[:x_copy_from])
      manifest_creation do |manifest|
        manifest.sw_objects = copied_manifest.sw_objects
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
    sw_object = SwObject.find_by_uri(json_params[:uri]) || SwManifest.find_by_uri(json_params[:uri])

    if sw_object
      app.status 204
      sw_object.destroy
    else
      app.status 404
    end
  end

  private

  def object_creation
    sw_object = SwObject.find_or_create_by_uri(json_params[:uri])

    yield
    file_path = "storage/#{json_params[:uri]}"

    sw_object.update_attributes(
      container: container,
      key: key,
      content_type: req_headers[:content_type],
      file_path: file_path,
      size: File.size(file_path),
      md5: Digest::MD5.file(file_path).hexdigest
    )

    safe_append_header('X-Timestamp', sw_object.created_at.to_i)
    safe_append_header('Date', Time.now)
    app.status 201
  end

  def manifest_creation
    sw_manifest = SwManifest.find_or_create_by_uri(json_params[:uri])
    sw_manifest.update_attributes(container: container, key: key, content_type: req_headers[:content_type])

    yield(sw_manifest)

    safe_append_header('X-Timestamp', sw_manifest.created_at.to_i)
    safe_append_header('Date', Time.now)
    app.status 201
  end
end
