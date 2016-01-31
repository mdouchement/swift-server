require 'swift_server'

use Rack::Logger

helpers do
  def logger
    request.logger
  end
end

SuperModel::Marshal.path = 'dump.db'
SuperModel::Marshal.load

at_exit do
  SuperModel::Marshal.dump
end

run SwiftServer::Router
