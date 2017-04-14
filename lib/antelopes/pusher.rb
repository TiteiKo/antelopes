# frozen_string_literal: true

module Antelopes
  # Class used to push jobs in the todo queue
  # This should not be used directly by Antelopes users.
  #
  # @since x.x.x
  # @private
  class Pusher
    # Initialization
    #
    # @param logger [ServerEngine::DaemonLogger] a logger
    # @param redis [Redis] a {https://github.com/redis/redis-rb redis} connection
    def initialize(logger: nil, redis: nil)
      @logger = logger || ServerEngine::DaemonLogger.new($stdout)
      @redis = redis || Antelopes::Redis.new.connection
    end

    # Mechod that actually adds the job to queue
    #
    # @example Enqueing a job
    #   result = Antelopes::Pusher.new.call(
    #     job: Hash[class: 'MyClass', method: 'call', args: Hash[foo: 'bar']]
    #   )
    #   result.jid
    #
    # @param job_params [Hash] parameters of the job
    # @return [OpenStruct] response object
    def call(job_params)
      @result = OpenStruct.new(jid: SecureRandom.uuid)

      redis.set("antelopes:job:#{@result.jid}", JSON.generate(job_params.merge(jid: @result.jid)))
      redis.rpush('antelopes:todo', @result.jid)

      @result
    end

    private

    attr_reader :redis, :logger
  end
end
