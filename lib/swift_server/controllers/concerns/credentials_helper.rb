module SwiftServer
  module Controllers
    module Concerns
      module CredentialsHelper
        def valid_tenant?(tenant)
          tenant == expected_tenant
        end

        def valid_username?(username)
          username == expected_username
        end

        def valid_password?(password)
          password == expected_password
        end

        def expected_tenant
          env(:swift_storage_tenant) || 'test'
        end

        def expected_username
          env(:swift_storage_username) || 'tester'
        end

        def expected_password
          env(:swift_storage_password) || 'testing'
        end

        private

        def env(key)
          ENV[key.to_s.upcase]
        end
      end
    end
  end
end
