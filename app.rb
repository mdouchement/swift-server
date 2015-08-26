require 'sinatra/verbs'

Sinatra::Verbs.custom :copy

before do
  content_type :json
  if (token = req_headers[:x_auth_token])
    halt 401 if token != 'tk_tester'
  end
end

#
##############
# SWIFT      #
##############
#
# http://developer.openstack.org/api-ref-objectstorage-v1.html

# List all containers
get '/v1/AUTH_tester/' do
  logger.info 'containers_controller#index'
  ContainersController.new(*args).index
end

# Show container metadata (check existence)
head '/v1/AUTH_tester/:container' do |container|
  logger.info 'containers_controller#show'
  json_params[:container] = container
  json_params[:method] = :head
  ContainersController.new(*args).show
end

# Show container details and list objects
get '/v1/AUTH_tester/:container' do |container|
  logger.info 'containers_controller#show'
  json_params[:container] = container
  json_params[:method] = :get
  ContainersController.new(*args).show
end

# Create container
put '/v1/AUTH_tester/:container' do |container|
  logger.info 'containers_controller#update'
  json_params[:container] = container
  ContainersController.new(*args).update
end

# Delete container
delete '/v1/AUTH_tester/:container' do |container|
  logger.info 'containers_controller#destroy'
  json_params[:container] = container
  ContainersController.new(*args).destroy
end

# Show object metadata (check existence)
head '/v1/AUTH_tester/*' do |uri|
  logger.info 'sw_objects_controller#show'
  json_params[:uri] = uri
  json_params[:method] = :head
  SwObjectsController.new(*args).show
end

# Get object content and metadata
get '/v1/AUTH_tester/*' do |uri|
  logger.info 'sw_objects_controller#show'
  json_params[:uri] = uri
  json_params[:method] = :get
  SwObjectsController.new(*args).show
end

# Create or replace object
# Copy object
put '/v1/AUTH_tester/*' do |uri|
  json_params[:uri] = uri
  if req_headers[:x_copy_from]
    logger.info 'sw_objects_controller#copy'
    SwObjectsController.new(*args).copy
  else
    logger.info 'sw_objects_controller#update'
    SwObjectsController.new(*args).update
  end
end

copy '/v1/AUTH_tester/*' do |uri|
  json_params[:uri] = req_headers[:destination]
  req_headers[:x_copy_from] = uri
  logger.info 'sw_objects_controller#copy'
  SwObjectsController.new(*args).copy
end

# Delete object
delete '/v1/AUTH_tester/*' do |uri|
  logger.info 'sw_objects_controller#destroy'
  json_params[:uri] = uri
  SwObjectsController.new(*args).destroy
end

#
##############
# KEYSTONE 1 #
##############
#

# Authenticate
get '/auth/v1.0' do
  logger.info 'keystone1_controller#show'
  Keystone1Controller.new(*args).show
end

#
##############
# KEYSTONE 2 #
##############
#
# http://developer.openstack.org/api-ref-identity-v2.html

# Authenticate
post '/v2.0/tokens' do
  logger.info 'keystone2_controller#create'
  Keystone2Controller.new(*args).create
end

#
##############
# HELPERS    #
##############
#

def json_params
  @json_params ||= if request.env['CONTENT_TYPE'] == 'application/json'
                     JSON.parse(request.body.read, symbolize_names: true) || {}
                   else
                     {}
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
