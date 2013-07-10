require 'zk'
require 'dcell/registry'
require 'dcell/registries/base'

module DCell
  module Registry
    class ZkAdapter < Base
      PREFIX  = "/dcell"
      DEFAULT_PORT = 2181

      # Create a new connection to Zookeeper
      #
      # servers: a list of Zookeeper servers to connect to. Each server in the
      #          list has a host/port configuration
      def initialize(options)
        # Stringify keys :/
        options = options.inject({}) { |h,(k,v)| h[k.to_s] = v; h }

        @env = options['env'] || 'production'
        @base_path = "#{PREFIX}/#{@env}"

        # Let them specify a single server instead of many
        server = options['server']
        if server
          servers = [server]
        else
          servers = options['servers']
          raise "no Zookeeper servers given" unless servers
        end

        # Add the default Zookeeper port unless specified
        servers.map! do |server|
          if server[/:\d+$/]
            server
          else
            "#{server}:#{DEFAULT_PORT}"
          end
        end

        @zk = ZK.new(*servers)
      end

      def get(namespace, key)
        path = File.join(@base_path, namespace.to_s, key)
        result, _ = @zk.get(path)
        Marshal.load(result)
      rescue ZK::Exceptions::NoNode
      end

      def set(namespace, key, value)
        path = File.join(@base_path, namespace.to_s, key)
        string = Marshal.dump(value)
        @zk.set(path, string)
      rescue ZK::Exceptions::NoNode
        @zk.create(path, string, ephemeral: (namespace == :nodes))
      end

      def keys(namespace)
        @zk.children(File.join(@base_path, namespace.to_s))
      end

      def clear(namespace)
        path = File.join(@base_path, namespace.to_s)
        @zk.rm_rf(path)
        @zk.mkdir_p(path)
      end
    end
  end
end
