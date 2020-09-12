module SwiftServer
  module Controllers
    class Keystone3 < ApplicationController
      include Concerns::CredentialsHelper

      def create
        app.status 401
      end
    end
  end
end
