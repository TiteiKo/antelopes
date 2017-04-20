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
      @redis.with do |c|
        assert_includes c.keys('antelopes:*'), "antelopes:job:#{result.jid}"
        assert_equal 1, c.llen('antelopes:todo')
      end
    end

    private

    def clean_redis
      @redis.with do |c|
        c.keys('antelopes:*').each do |key|
          c.del(key)
        end
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
