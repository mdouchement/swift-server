When(/^I download a file from \/(\S+)$/) do |uri|
  FileGenerator.with_empty_file do |file|
    SwiftClient[:source].parse_params(uri)
    SwiftClient[:source].expected_size = SwiftClient[:source].object_size

    SwiftClient[:source].download(file)

    SwiftClient[:source].file_exist = File.exist?(file.path)
    SwiftClient[:source].actual_size = file.size
  end
end
