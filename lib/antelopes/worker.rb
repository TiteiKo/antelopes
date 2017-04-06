# frozen_string_literal: true

module Antelopes
  # Basic worker that pulls a job, runs it, reports and repeats.
  #
  # @since x.x.x
  # @private
  class Worker
    # Worker initialization.
    #
    # @param logger [ServerEngine::DaemonLogger] a logger
    def initialize(logger = ServerEngine::DaemonLogger.new($stdout))
      @logger = logger
    end

    # Method called by the looper at every loop.
    #
    # @since x.x.x
    def run
      logger.info 'Worker is working!'
    end

    private

    attr_reader :logger
  end
end
