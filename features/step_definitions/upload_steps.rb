When(/^I upload a tiny file to \/(\S+)$/) do |uri|
  FileGenerator.with_lorem_file(10) do |file|
    SwiftClient[:source].parse_params(uri)
    SwiftClient[:source].expected_size = file.size

    SwiftClient[:source].upload(file)

    SwiftClient[:source].actual_size = SwiftClient[:source].object_size
  end
end

When(/^I upload a large file to \/(\S+)$/) do |uri|
  FileGenerator.with_lorem_file(30) do |file|
    SwiftClient[:source].parse_params(uri)
    SwiftClient[:source].expected_size = file.size

    SwiftClient[:source].multipart_upload(file)

    SwiftClient[:source].actual_size = SwiftClient[:source].object_size
  end
end
