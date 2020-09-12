module SwiftServer
  module Controllers
    class Keystone2 < ApplicationController
      include Concerns::CredentialsHelper

      def create
        if authorize
          app.status 201
          JSON.pretty_generate(
            access: {
              token: {
                id: 'tk_tester',
                expires: (Time.now.utc + 1.hour).to_s
              },
              serviceCatalog: [
                {
                  type: 'object-store',
                  name: 'swift',
                  endpoints: [
                    {
                        adminURL: "http://localhost:60080",
                        region: 'ShangriLa',
                        internalURL: app.url('/v1/AUTH_tester'),
                        id: 'trololo_id',
                        publicURL: app.url('/v1/AUTH_tester')
                    }
                  ],
                  endpoints_links: []
                }
              ]
            }
          )
        else
          app.status 401
        end
      end

      private

      def authorize
        case
        when (p = json_params[:auth][:passwordCredentials])
          authorize_password(p)
        when (p = json_params[:auth][:'RAX-KSKEY:apiKeyCredentials'])
          authorize_rax_kskey(p)
        when (p = json_params[:auth][:apiAccessKeyCredentials])
          authorize_api(p)
        end
      end

      def authorize_password(p)
        valid_tenant?(tenant) && valid_username?(p[:username]) && valid_password?(p[:password])
      end

      def authorize_rax_kskey(p)
        valid_tenant?(tenant) && valid_username?(p[:username]) && valid_password?(p[:apiKey])
      end

      def authorize_api(p)
        valid_tenant?(tenant) && valid_username?(p[:username]) && valid_password?(p[:secretKey])
      end

      def tenant
        json_params[:auth][:tenantName] || json_params[:auth][:tenantId]
      end
    end
  end
end
