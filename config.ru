$LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'rubygems'
require 'sinatra'
require 'sinatra/verbs'
require 'json'
require 'supermodel'
Gem::Specification.find_by_name('swift_server').gem_dir.tap do |pwd|
  require File.join(pwd, 'app')
  Dir[File.join(pwd, '{controllers,models}', '**', '*.rb')].sort.each { |f| require f }
end

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
