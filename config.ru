require 'swift_server'

use Rack::Logger

helpers do
  def logger
    request.logger.level = Logger::INFO
    request.logger
  end
end

SwiftServer::Models::load("dump.db.json")
at_exit do
  SwiftServer::Models::backup("dump.db.json")
end

run SwiftServer::Router
