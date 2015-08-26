module SwObjectHelper
  def persist(io)
    File.open(file_path, 'w') do |file|
      file << io.read
    end
    "storage/#{json_params[:uri]}"
  end

  def copy_file
    FileUtils.cp(copied_file_path, file_path)
    "storage/#{json_params[:uri]}"
  end

  def key
    @key ||= json_params[:uri].split('/')[1..-1].join('/')
  end

  def container
    @container ||= Container.find_by_name(container_name)
  end

  def container_name
    @container_name ||= json_params[:uri].split('/').first
  end

  def copied_from_key
    @copied_from_key ||= req_headers[:x_copy_from].split('/')[1..-1].join('/')
  end

  def copied_from_container
    @copied_from_container ||= Container.find_by_name(container_name)
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
