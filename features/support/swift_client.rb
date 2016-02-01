require 'swift-storage'

class SwiftClient
  attr_accessor :expected_size, :actual_size,
                :file_exist, :previous_scenario_key, :error

  module ClassMethods
    # Define singleton clients
    def [](id)
      @clients ||= {}
      @clients[id] ||= new
    end

    def each_client
      @clients.each do |id, client|
        yield id, client
      end
    end

    # Removes all existing clients
    def wipe
      @clients.clear
    end
  end
  extend ClassMethods

  # {parse_params} is required after instanciation of each client
  def parse_params(uri)
    uri.split('/').tap do |elts|
      @container_name = elts.first
      @object_name = elts[1..-1].join('/')
    end
  end

  def params
    [@container_name, @object_name]
  end

  def upload(file)
    delete_object_if_exists
    create_object(*params).write(file, content_type: 'application/octet-stream')
  end

  # Uploads that use Manifest
  def multipart_upload(file)
    delete_object_if_exists
    FileSpliter.split_into_files(file.path).each do |part_path|
      File.open(part_path) do |input|
        # Upload parts
        #  path example: `cucumber_container/cucumber_object/lorem.txt/part_00000'
        create_object(*params).write(input, content_type: 'application/octet-stream',
                                            part_location: part_location(part_path))
      end
      File.unlink(part_path) # Remove part from file system
    end
    # Create the manifest
    #   path example: `cucumber_container/cucumber_object/lorem.txt/'
    create_object(*params).write(object_manifest: part_location(''), content_type: 'application/octet-stream')
  end

  def download(file)
    object(*params).read(file)
  end

  def copy(src_params)
    create_object(*params).copy_from object(*src_params)
  end

  def object_size
    object(*params).content_length.to_i
  end

  def object_exists?
    object(*params).exists?
  end

  def delete_object_if_exists
    object(*params).delete if object_exists?
  end

  def create_object(container, object)
    create_container(container).objects[object]
  end

  def object(container, object)
    container(container).objects[object]
  end

  def create_container(container)
    container(container).tap do |c|
      c.create unless c.exists?
    end
  end

  def container(container)
    swift.containers[container]
  end

  def delete_objects(container = nil, objects = nil)
    container ||= @container_name
    objects ||= [@object_name]

    c = container(container)
    objects.each { |o| c.objects[o].delete }
  end

  def part_location(part_path)
    File.join(@container_name, @object_name, File.basename(part_path))
  end

  def swift
    @swift ||= ::SwiftStorage::Service.new(
        tenant: ENV['SWIFT_STORAGE_TENANT'],
        username: ENV['SWIFT_STORAGE_USERNAME'],
        password: ENV['SWIFT_STORAGE_PASSWORD'],
        endpoint: 'http://localhost:10101'
      ).tap(&:authenticate!)
  end
end
