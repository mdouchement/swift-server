require 'sinatra'
require 'sinatra/verbs'
require 'json'
require 'supermodel'

Gem::Specification.find_by_name('swift_server').gem_dir.tap do |pwd|
  Dir[File.join(pwd, 'lib', 'swift_server', '{controllers,models}', '**', '*.rb')].sort.each { |f| require f }
end

module SwiftServer
  class Router < Sinatra::Base
    include RouterHelper
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
      Controllers::ContainersController.new(*args).index
    end

    # Show container metadata (check existence)
    head '/v1/AUTH_tester/:container' do |container|
      logger.info 'containers_controller#show'
      json_params[:container] = container
      json_params[:method] = :head
      Controllers::ContainersController.new(*args).show
    end

    # Show container details and list objects
    get '/v1/AUTH_tester/:container' do |container|
      logger.info 'containers_controller#show'
      json_params[:container] = container
      json_params[:method] = :get
      Controllers::ContainersController.new(*args).show
    end

    # Create container
    put '/v1/AUTH_tester/:container' do |container|
      logger.info 'containers_controller#update'
      json_params[:container] = container
      Controllers::ContainersController.new(*args).update
    end

    # Delete container
    delete '/v1/AUTH_tester/:container' do |container|
      logger.info 'containers_controller#destroy'
      json_params[:container] = container
      Controllers::ContainersController.new(*args).destroy
    end

    # Show object metadata (check existence)
    head '/v1/AUTH_tester/*' do |uri|
      logger.info 'sw_objects_controller#show'
      json_params[:uri] = uri
      json_params[:method] = :head
      Controllers::ObjectsController.new(*args).show
    end

    # Get object content and metadata
    get '/v1/AUTH_tester/*' do |uri|
      logger.info 'sw_objects_controller#show'
      json_params[:uri] = uri
      json_params[:method] = :get
      Controllers::ObjectsController.new(*args).show
    end

    # Create or replace object
    # Copy object
    put '/v1/AUTH_tester/*' do |uri|
      if req_headers[:x_copy_from]
        logger.info 'sw_objects_controller#copy'
        json_params[:uri] = uri
        Controllers::ObjectsController.new(*args).copy
      elsif req_headers[:x_object_manifest]
        logger.info 'sw_objects_controller#manifest'
        json_params[:uri] = uri
        json_params[:x_object_manifest] = req_headers[:x_object_manifest]
        Controllers::ObjectsController.new(*args).manifest
      else
        logger.info 'sw_objects_controller#update'
        req_headers[:x_write_object] = true
        json_params[:uri] = uri
        Controllers::ObjectsController.new(*args).update
      end
    end

    # Copy object
    copy '/v1/AUTH_tester/*' do |uri|
      json_params[:uri] = req_headers[:destination]
      req_headers[:x_copy_from] = uri
      logger.info 'sw_objects_controller#copy'
      Controllers::ObjectsController.new(*args).copy
    end

    # Delete object
    delete '/v1/AUTH_tester/*' do |uri|
      logger.info 'sw_objects_controller#destroy'
      json_params[:uri] = uri
      Controllers::ObjectsController.new(*args).destroy
    end

    #
    ##############
    # KEYSTONE 1 #
    ##############
    #

    # Authenticate
    get '/auth/v1.0' do
      logger.info 'keystone1_controller#show'
      Controllers::Keystone1Controller.new(*args).show
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
      Controllers::Keystone2Controller.new(*args).create
    end
  end
end
