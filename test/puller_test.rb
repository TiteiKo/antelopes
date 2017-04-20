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

      assert_equal @jid, result.jid

      @redis.with do |c|
        assert_includes c.keys('antelopes:*'), "antelopes:job:#{result.jid}"
        assert_equal 0, c.llen('antelopes:todo')
        assert_equal 1, c.llen('antelopes:doing')
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

    def logger
      @logger ||= begin
        l = Logger.new($stdout)
        l.level = Logger::ERROR
        l
      end
    end
  end
end
