When(/^I remove several existing objects "(.+)" from container \/(\S+)$/) do |objects, container|
  begin
    SwiftClient[:source].delete_objects(container, objects.split('|'))
  rescue => e
    SwiftClient[:source].error = e
  end
end
