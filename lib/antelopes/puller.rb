# frozen_string_literal: true

module Antelopes
  # Class used to pull jobs
  # This should not be used directly by Antelopes users.
  #
  # @since 0.0.1
  # @private
  class Puller
    # Initialization
    #
    # @param logger [ServerEngine::DaemonLogger] a logger
    # @param redis [Redis] a {https://github.com/redis/redis-rb redis} connection
    def initialize(logger: nil, redis: nil)
      @logger = logger || ServerEngine::DaemonLogger.new($stdout)
      @redis = redis || Antelopes::Redis.new.connection
    end

    # Method used by the workers to get a job to work on.
    # When the job is started, it goes in the 'doing' list.
    #
    # @return [Antelopes::Job] the job
    def next_todo
      jid = redis.with { |c| c.brpoplpush('antelopes:todo', 'antelopes:doing', timeout: 1) }

      return if jid.nil?
      Job.new(JSON.parse(redis.with { |c| c.get("antelopes:job:#{jid}") }))
    end

    private

    attr_reader :redis, :logger
  end
end
