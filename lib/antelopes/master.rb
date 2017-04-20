# frozen_string_literal: true

module Antelopes
  # ServerEngine master.
  # Its job is to create a connection pool towards Redis and
  # share it with the loopers.
  # This class should not be used directly by Antelopes users.
  #
  # @since 0.0.1
  # @private
  module Master
    # @!attribute [r] redis
    #   @return [ConnectionPool] the redis connection pool
    attr_reader :redis

    # Method called by ServerEngine before starting the workers.
    # It initialize the redis connection pool used by the Loopers.
    #
    # @since 0.0.1
    def before_run
      logger.info 'Master starting'
      @redis = Antelopes::Redis.new(size: 5).connection
    end

    # Method called by ServerEngine before shutting down
    #
    # @since 0.0.1
    def after_run
      logger.info 'Master shutting down'
      @redis.shutdown(&:quit)
    end
  end
end
