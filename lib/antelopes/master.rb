# frozen_string_literal: true

module Antelopes
  # ServerEngine master.
  # Its job is to create a connection pool towards Redis and
  # share it with the loopers.
  # This class should not be used directly by Antelopes users.
  #
  # @since x.x.x
  # @private
  module Master
    # Method called by ServerEngine before starting the workers.
    #
    # @since x.x.x
    # @todo Initialize the redis connection pool here
    def before_run
      logger.info 'Master started'
    end

    # Method called by ServerEngine before shutting down
    #
    # @since x.x.x
    def after_run
      logger.info 'Master shutting down'
    end
  end
end
