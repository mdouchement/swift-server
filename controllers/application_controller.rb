class ApplicationController
  attr_reader :app, :json_params, :req_headers, :resp_headers

  def initialize(app, json_params, req_headers, resp_headers)
    @app = app
    @json_params = json_params
    @req_headers = req_headers
    @resp_headers = resp_headers
  end

  private

  # Convenient way to respect Rack::Lint rules
  def safe_append_header(key, value)
    resp_headers[key] = value.to_s
  end
end
