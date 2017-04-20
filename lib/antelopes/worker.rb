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
    # @param puller
    def initialize(logger: ServerEngine::DaemonLogger.new($stdout), puller:)
      @logger = logger
      @puller = puller
    end

    # Method called by the looper at every loop.
    #
    # @since x.x.x
    def run
      job = puller.pull
      return if job.nil?

      klass = Object.const_get(job.job_class)
      if job.job_method.nil?
        klass.public_send(job.job_class_method, **job.job_args)
      else
        klass.new.public_send(job.job_method, **job.job_args)
      end
    end

    private

    attr_reader :logger, :puller
  end
end
