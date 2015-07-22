class Keystone1Controller < ApplicationController
  def show
    if authorize
      safe_append_header('X-Storage-Url', app.url('/v1/AUTH_tester'))
      safe_append_header('X-Auth-Token', 'tk_tester')
      safe_append_header('X-Storage-Token', 'stk_tester')
      app.status 200
    else
      app.status 401
    end
  end

  private

  def authorize
    req_headers[:x_auth_user] == 'test:tester' && req_headers[:x_auth_key] == 'testing'
  end
end
