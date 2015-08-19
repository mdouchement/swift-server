require 'dante'
require 'rack'

module SwiftServer
  module Server
    module_function

    def start
      init
      Dante::Runner.new('swift-server')
        .execute(daemonize: true, pid_path: @swift_pid, log_path: @swift_log) do |opts|
        app = Rack::Builder.new do
          eval File.read(File.join(SwiftServer::Server.pwd, '..', '..', 'config.ru'))
        end
        Rack::Server.start(app: app, Port: 101001)
      end
    end

    def stop
      Dante::Runner.new('swift-server').execute(kill: true, pid_path: @swift_pid)
    end

    def init
      id = Time.now.utc.strftime('%Y%m%d%H%M%S')
      @swift_pid = "/tmp/swift-server-#{id}.pid"
      @swift_log = "/tmp/swift-server-#{id}.log"
    end

    def pwd
      File.dirname(File.expand_path(__FILE__))
    end
  end
end
