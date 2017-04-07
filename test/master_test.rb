# frozen_string_literal: true

module Antelopes
  class MasterTest < Minitest::Test
    def setup
      @master = Antelopes::MasterTest::TestMaster.new
    end

    def test_redis_connection_access
      @master.before_run

      @master.redis.with do |conn|
        conn.set 'test_redis_connection_access', 'OK'
        assert_equal 'OK', conn.get('test_redis_connection_access')
        conn.del 'test_redis_connection_access'
      end
    end

    class TestMaster
      include Antelopes::Master

      def logger
        @logger ||= begin
          logger = Logger.new($stdout)
          logger.level = Logger::ERROR
          logger
        end
      end
    end
  end
end
