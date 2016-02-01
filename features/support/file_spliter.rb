module FileSpliter
  MEGABYTE = 1_048_576
  DEFAULT_OFFSET = 10 * MEGABYTE

  module_function

  def nb_of_parts(file, offset = DEFAULT_OFFSET)
    (File.size(file).to_f / offset).ceil
  end

  def split_into_files(file_path, offset = DEFAULT_OFFSET)
    dir = "/tmp/swift_multiparts/#{Time.now.to_i}"
    FileUtils.mkdir_p(dir)
    basepath = File.join(dir, 'part_')
    part_paths = []
    nb_of_parts(file_path).times do |i|
      part_paths << basepath + i.to_s.rjust(5, '0')
      File.open(basepath + i.to_s.rjust(5, '0'), 'wb') do |tmp_file|
        tmp_file.write(IO.binread(file_path, offset, offset * i))
      end
    end
    part_paths
  end

  def exists?(part_path, part_number, file_path, offset = DEFAULT_OFFSET)
    if @nb_of_parts == part_number + 1
      File.exist?(part_path) &&
        File.size(part_path) == File.size(file_path).to_f - ((@nb_of_parts - 1) * offset)
    else
      File.exist?(part_path) && File.size(part_path) == offset
    end
  end
end
