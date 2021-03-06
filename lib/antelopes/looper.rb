# frozen_string_literal: true

module Antelopes
  # ServerEngine looper.
  # It has two ways of working: either as a simple worker or
  # as a manager.
  # This class should not be used directly by Antelopes users.
  #
  # @since 0.0.1
  # @private
  module Looper
    # Method called by {https://github.com/treasure-data/serverengine ServerEngine}
    # that loops until stopped.
    #
    # @since 0.0.1
    def run
      logger.info 'Looper started'

      @puller = Antelopes::Puller.new(logger: logger, redis: server.redis)
      @runner = Antelopes::Worker.new(logger: logger, redis: server.redis, puller: @puller)

      @runner.run until @stop
    rescue StandardError => e
      logger.error(e)
    end

    # Method called by {https://github.com/treasure-data/serverengine ServerEngine}
    # to stop the worker when the service receives a signal to stop or restart.
    #
    # @since 0.0.1
    def stop
      logger.info 'Looper shutting down'
      @stop = true
    end
  end
end
