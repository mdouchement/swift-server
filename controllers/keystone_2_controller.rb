class Keystone2Controller < ApplicationController
  def create
    if authorize
      app.status 201
      {
        access: {
          token: {
            id: 'tk_tester'
          },
          serviceCatalog: [
            {
              type: 'object-store',
              name: 'swift',
              endpoints: [
                {
                    adminURL: "http://23.253.72.207:8080",
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
      }.to_json
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
    tenant == 'test' && p[:username] == 'tester' && p[:password] == 'testing'
  end

  def authorize_rax_kskey(p)
    tenant == 'test' && p[:username] == 'tester' && p[:apiKey] == 'testing'
  end

  def authorize_api(p)
    tenant == 'test' && p[:accessKey] == 'tester' && p[:secretKey] == 'testing'
  end

  def tenant
    json_params[:auth][:tenantName] || json_params[:auth][:tenantId]
  end
end
