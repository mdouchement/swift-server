$LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'rubygems'
require 'sinatra'
require 'json'
require 'supermodel'
require 'app'
Dir[File.join('{controllers,models}', '**', '*.rb')].sort.each { |f| require f }

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

run Sinatra::Application
