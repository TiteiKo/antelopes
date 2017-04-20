# frozen_string_literal: true

module Antelopes
  class MainTest < Minitest::Test
    def setup
      @redis = Antelopes::Redis.new.connection
      clean_redis
    end

    def teardown
      clean_redis
    end

    def test_job_enqueuing
      assert_output(/Pushed.*Antelopes::MainTest::TestJob/) do
        Antelopes.push('Antelopes::MainTest::TestJob', method: 'call', args: Hash[foo: 'bar'])
      end
    end

    private

    def clean_redis
      @redis.keys('antelopes:*').each do |key|
        @redis.del(key)
      end
    end

    class TestJob
      def call(foo:)
        Logger.new($stdout).info("Job is running #call with foo: #{foo}")
      end
    end
  end
end
