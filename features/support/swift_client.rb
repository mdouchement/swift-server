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
      @clients.each do |client|
        yield client
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
    object(*params).write(file, content_type: 'application/octet-stream')
  end

  def download(file)
    object(*params).read(file)
  end

  def copy
  end

  def object_size
    object(*params).content_length.to_i
  end

  def object_exists?
    object(*params).exists?
  end

  def object(container, object)
    container(container).objects[object]
  end

  def create_container(container)
    container(container).create
  end

  def container(container)
    swift.containers[container]
  end

  def delete_objects(container, objects)
    c = container(container)
    objects.each { |o| c.objects[o].delete }
  end

  def swift
    ::SwiftStorage::Service.new(
        tenant: ENV['SWIFT_STORAGE_TENANT'],
        username: ENV['SWIFT_STORAGE_USERNAME'],
        password: ENV['SWIFT_STORAGE_PASSWORD'],
        endpoint: 'http://localhost:10101'
      ).tap(&:authenticate!)
  end
end
