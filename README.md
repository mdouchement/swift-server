# Swift-server

[![Circle CI](https://circleci.com/gh/mdouchement/swift-server.svg?style=shield)](https://circleci.com/gh/mdouchement/swift-server)

**Only for development and test purpose.**

Swift-server is a Sinatra server that responds to the same calls Openstack Swift responds to. It's a convenient way to use Swift out-of-the-box without any fancy dependencies and configuration.

Swift-server doesn't support all of the Swift command set, but the basic ones like upload, download, list, copy, authentication, and make containers are supported. More coming soon™. See file [app.rb](https://github.com/mdouchement/swift-server/blob/master/app.rb) for supported commands.

## Requirements
- MRI (developmed on 2.7.1)
- bundler

## Installing
```bash
$ bundle install
```

## Running
```bash
$ export WEB_CONCURRENCY=3
$ bundle exec unicorn -p 10101 -c config/unicorn.rb

# http://localhost:10101
# tenant: test
# username: tester
# password: testing

# http://localhost:10101/v3
# tenant: test
# domain: Default
# region: RegionOne
# name: tester
# password: testing

# storage token: tk_tester
```

Environment variables:
```
WEB_CONCURRENCY
SWIFT_STORAGE_TENANT
SWIFT_STORAGE_DOMAIN
SWIFT_STORAGE_USERNAME
SWIFT_STORAGE_PASSWORD
```

## Development
```bash
$ bundle install
$ SWIFT_STORAGE_TENANT=test SWIFT_STORAGE_USERNAME=tester SWIFT_STORAGE_PASSWORD=testing bundle exec rerun -b -- rackup -o localhost -p 10101
```

## License

MIT. See the [LICENSE](https://github.com/mdouchement/swift-server/blob/master/LICENSE) for more details.

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Ensure specs and Rubocop pass
5. Push to the branch (git push origin my-new-feature)
6. Create new Pull Request
