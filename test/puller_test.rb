# frozen_string_literal: true

module Antelopes
  class PullerTest < Minitest::Test
    def setup
      @redis = Antelopes::Redis.new.connection
      @puller = Antelopes::Puller.new(redis: @redis, logger: logger)
      clean_redis

      @jid = Antelopes::Pusher.new(redis: @redis, logger: logger).call(
        job: Hash[class: 'MyClass', method: 'call', args: Hash[foo: 'bar']]
      ).jid
    end

    def teardown
      clean_redis
    end

    def test_job_pulling
      result = @puller.next_todo

      assert_equal @jid, result['jid']
      assert_includes @redis.keys('antelopes:*'), "antelopes:job:#{result['jid']}"
      assert_equal 0, @redis.llen('antelopes:todo')
      assert_equal 1, @redis.llen('antelopes:doing')
    end

    private

    def clean_redis
      @redis.keys('antelopes:*').each do |key|
        @redis.del(key)
      end
    end

    def logger
      @logger ||= begin
        l = Logger.new($stdout)
        l.level = Logger::ERROR
        l
      end
    end
  end
end
