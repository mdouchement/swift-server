module SwiftServer
  module RouterHelper
    def json_params
      @json_params ||= if !req_headers[:x_write_object] && request.env['CONTENT_TYPE'] == 'application/json'
                         params.merge(JSON.parse(request.body.read, symbolize_names: true)) || params
                       else
                         params
                       end
    end

    def req_headers
      @req_headers ||= Hash[
        request.env.select { |k, v| k.start_with? 'HTTP_' }
          .map { |k, v| [k.sub('HTTP_', '').downcase.to_sym, v] }
      ]
    end

    def resp_headers
      headers
    end

    def args
      return self, json_params, req_headers, resp_headers
    end
  end
end
