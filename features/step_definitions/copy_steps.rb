When(/^I copy an existing object to \/(\S+)$/) do |uri|
  # src (Given clause)
  SwiftClient[:destination].expected_size = SwiftClient[:source].object_size

  # dst (When clause)
  SwiftClient[:destination].parse_params(uri)
  SwiftClient[:destination].copy(SwiftClient[:source].params)

  SwiftClient[:destination].actual_size = SwiftClient[:destination].object_size
end
