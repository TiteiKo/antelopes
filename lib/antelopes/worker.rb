# frozen_string_literal: true

module Antelopes
  # Basic worker that pulls a job, runs it, reports and repeats.
  #
  # @since 0.0.1
  # @private
  class Worker
    # Worker initialization.
    #
    # @param logger [ServerEngine::DaemonLogger] a logger
    # @param puller [Antelopes::Puller] a puller instance
    # @param redis [ConnectionPool] a redis connection pool
    def initialize(logger: nil, puller: nil, redis: nil)
      @logger = logger || ServerEngine::DaemonLogger.new($stdout)
      @redis  = redis  || Antelopes::Redis.new.connection
      @puller = puller || Antelopes::Puller.new(logger: @logger, redis: @redis)
    end

    # Method called by the looper at every loop.
    #
    # @since 0.0.1
    def run
      job = puller.next_todo
      return if job.nil?

      method = job.job_method.nil? ? job.job_class_method : job.job_method

      execute(target(job), method, job)
    rescue StandardError => e
      logger.error(e)
    end

    private

    attr_reader :logger, :puller

    # Method that sends the job method to the job class or instance, with or
    # without args
    #
    # @private
    # @since x.x.x
    def execute(target, method, job)
      if job.job_args.nil?
        target.public_send(method)
      else
        target.public_send(method, **job.job_args)
      end
    end

    # Method that returns the class or class instance upon which the
    # job method must be called
    #
    # @param job [Antelopes::Job] the job
    # @return [Class] if the job is with a class method
    # @return [Object] instance of the job class if the job is with an
    #   instance method
    def target(job)
      klass = Object.const_get(job.job_class)
      job.job_method.nil? ? klass : klass.new
    end
  end
end
