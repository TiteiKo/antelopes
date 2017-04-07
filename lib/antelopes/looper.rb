# frozen_string_literal: true

module Antelopes
  # ServerEngine looper.
  # It has two ways of working: either as a simple worker or
  # as a manager.
  # This class should not be used directly by Antelopes users.
  #
  # @since x.x.x
  # @private
  module Looper
    # Method called by [serverengine](https://github.com/treasure-data/serverengine)
    # that loops until stopped.
    #
    # @since x.x.x
    def run
      logger.info 'Looper started'
      @runner = Worker.new(logger: logger)
      @runner.run until @stop
    end

    # Method called by [serverengine](https://github.com/treasure-data/serverengine)
    # to stop the worker when the service receives a signal to stop or restart.
    #
    # @since x.x.x
    def stop
      logger.info 'Looper shuting down'
      @stop = true
    end
  end
end
