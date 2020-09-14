require 'swift_server'

use Rack::Logger

helpers do
  def logger
    request.logger.level = Logger::INFO
    request.logger
  end
end

SwiftServer::Models::load("storage/dump.db.json")
at_exit do
  SwiftServer::Models::backup("storage/dump.db.json")
end

run SwiftServer::Router
