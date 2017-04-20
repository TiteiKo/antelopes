# frozen_string_literal: true

module Antelopes
  # Class used to generate a Redis connection
  #
  # @since x.x.x
  class Redis
    # Retrieve a Redis connection
    #
    # @todo Make it configurable
    # @return [::Redis] a {https://github.com/redis/redis-rb Redis} connection
    def connection
      ::Redis.new
    end
  end
end
