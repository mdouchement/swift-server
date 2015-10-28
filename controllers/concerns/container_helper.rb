module ContainerHelper
  def list_objects(container, prefix, content_type)
    case content_type
    when 'application/json'
      JSON.pretty_generate(container.sw_objects.select { |o| o.key.start_with?(prefix) }
        .each_with_object([]) do |obj, res|
        res << {
          content_type: obj.content_type,
          bytes: obj.size,
          last_modified: obj.updated_at,
          hash: obj.md5
        }
      end)
    when 'text/plain'
      container.sw_objects.select { |o| o.key.start_with?(prefix) }.map(&:key).join("\n")
    end
  end
end
