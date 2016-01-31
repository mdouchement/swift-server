ENV['RACK_ENV'] ||= 'test'
ENV['RAILS_ENV'] ||= 'test'

# Initalize swift-server & swift_storage config
ENV['SWIFT_STORAGE_AUTH_VERSION'] = ['1.0', '2.0'].sample
ENV['SWIFT_STORAGE_TENANT'] = 'test'
ENV['SWIFT_STORAGE_USERNAME'] = 'tester'
ENV['SWIFT_STORAGE_PASSWORD'] = 'testing'
