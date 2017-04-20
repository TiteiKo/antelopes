# frozen_string_literal: true

module Antelopes
  # Class used to generate a Redis connection
  #
  # @since 0.0.1
  class Redis
    # @!attribute [r] connection
    #   @return [ConnectionPool] a redis connection pool
    attr_reader :connection

    def initialize(size: 1, timeout: 3)
      @connection = ConnectionPool.new(size: size, timeout: timeout) { ::Redis.new }
    end
  end
end
