require 'celluloid/redis'
require 'redis/connection/celluloid'
require 'redis-namespace'
require 'dcell/registry'
require 'dcell/registries/base'

module DCell
  module Registry
    class RedisAdapter < Registry::Base
      def initialize(options)
        # Convert all options to symbols :/
        options = options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }

        @env = options[:env] || 'production'
        @namespace = options[:namespace] || "dcell_#{@env}"

        redis  = ::Redis.new options
        @redis = ::Redis::Namespace.new @namespace, :redis => redis
      end

      def get(namespace, key)
        string = @redis.hget(namespace, key.to_s)
        Marshal.load(string) if string
      end

      def set(namespace, key, value)
        string = Marshal.dump(value)
        @redis.hset(namespace, key.to_s, string)
      end

      def delete(namespace, key)
        @redis.hdel(namespace, key.to_s)
      end

      def keys(namespace)
        @redis.hkeys(namespace)
      end

      def clear(namespace)
        @redis.del(namespace)
      end
    end
  end
end
