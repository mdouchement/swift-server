When(/^I upload a (\S+) file to \/(\S+)$/) do |size, uri|
  FileGenerator.with_lorem_file(convert_size(size)) do |file|
    SwiftClient[:source].parse_params(uri)
    SwiftClient[:source].expected_size = file.size

    SwiftClient[:source].upload(file)

    SwiftClient[:source].actual_size = SwiftClient[:source].object_size
  end
end

Then(/^I can verify the success of the upload$/) do
  expect(SwiftClient[:source].object_exists?).to be true
end

Then(/^I can verify the size$/) do
  SwiftClient.each_client do |client|
    expect(client.actual_size).to eq(client.expected_size)
  end
end

Then(/^I remove the object\(s\) for the next test$/) do
  SwiftClient.each_client do |client|
    client.delete_objects
  end
  SwiftClient.wipe
end

def convert_size(size)
  case size
  when 'tiny'
    1
  when 'large'
    200
  else
    fail 'Invalid size parameter'
  end
end
