# frozen_string_literal: true

module Antelopes
  class PusherTest < Minitest::Test
    def setup
      @redis = Antelopes::Redis.new.connection
      @pusher = Antelopes::Pusher.new(redis: @redis, logger: TestMaster.new.logger)
      clean_redis
    end

    def teardown
      clean_redis
    end

    def test_job_enqueuing
      result = @pusher.call(foo: 'bar')

      refute_nil result.jid
      assert_includes @redis.keys('antelopes:*'), "antelopes:job:#{result.jid}"
      assert_equal 1, @redis.llen('antelopes:todo')
    end

    private

    def clean_redis
      @redis.keys('antelopes:*').each do |key|
        @redis.del(key)
      end
    end

    class TestMaster
      include Antelopes::Master

      def logger
        @logger ||= begin
          l = Logger.new($stdout)
          l.level = Logger::ERROR
          l
        end
      end
    end
  end
end
