Then(/^I can verify the success of the upload$/) do
  expect(SwiftClient[:source].object_exists?).to be true
end

Then(/^I can verify the success of the download$/) do
  expect(SwiftClient[:source].file_exist).to be true
end

Then(/^I can verify the size$/) do
  SwiftClient.each_client do |_id, client|
    expect(client.actual_size).to eq(client.expected_size)
  end
end

Then(/^I can verify the success of the copy$/) do
  expect(SwiftClient[:source].object_exists?).to be true
  expect(SwiftClient[:destination].object_exists?).to be true
end

Then(/^I can verify the success of the deletion$/) do
  expect(SwiftClient[:source].error).to be nil
end

Then(/^I remove the object\(s\) for the next test$/) do
  SwiftClient.each_client do |_id, client|
    client.delete_objects
  end
  SwiftClient.wipe
end
