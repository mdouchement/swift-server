class ApplicationController
  attr_reader :app, :json_params, :req_headers, :resp_headers

  def initialize(app, json_params, req_headers, resp_headers)
    @app = app
    @json_params = json_params
    @req_headers = req_headers
    @resp_headers = resp_headers
  end
end
