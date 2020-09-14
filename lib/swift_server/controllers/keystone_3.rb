module SwiftServer
  module Controllers
    class Keystone3 < ApplicationController
      include Concerns::CredentialsHelper

      def create
        if authorize # Project-Scoped response
          app.status 201
          safe_append_header('X-Subject-Token', 'tk_tester')
          JSON.pretty_generate(
            token: {
              catalog: [
                {
                  endpoints: [
                    {
                        id: '068d1b359ee84b438266cb736d81de97',
                        interface: 'public',
                        region: 'RegionOne',
                        region_id: 'RegionOne',
                        url: app.url('/v1/AUTH_tester')
                    }
                  ],
                  type: 'object-store',
                  id: '050726f278654128aba89757ae25950c',
                  name: 'swift'
                }
              ],
              expires_at: Time.now + 1.month,
              issued_at: Time.now,
              is_domain: false,
            }
          )
        else
          app.status 401
        end
      end

      private

      def authorize
        case
        when (p = json_params.dig(:auth, :identity, :password))
          authorize_password(p)
        end
      end

      def authorize_password(p)
        valid_domain?(domain) && valid_tenant?(tenant) && valid_username?(p.dig(:user, :name)) && valid_password?(p.dig(:user, :password))
      end

      def domain
        json_params.dig(:auth, :scope, :project, :domain, :name)
      end

      def tenant
        json_params.dig(:auth, :scope, :project, :name)
      end
    end
  end
end
