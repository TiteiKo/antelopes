# frozen_string_literal: true

require 'test_helper'

module Antelopes
  class WorkerTest < Minitest::Test
    def test_running_pulled_job
      assert_output(/Job is running!/) do
        worker.run
      end
    end

    def test_no_error_when_no_job
      @puller = TestPullerWithoutJob.new
      worker.run
    end

    private

    def puller
      @puller ||= TestPullerWithJob.new
    end

    def worker
      @worker ||= Antelopes::Worker.new(puller: puller)
    end

    class TestPullerWithJob
      def pull
        Hash[job: 'Antelopes::WorkerTest::TestJob']
      end
    end

    class TestPullerWithoutJob
      def pull
        nil
      end
    end

    class TestJob
      def call(*)
        Logger.new($stdout).info('Job is running!')
      end
    end
  end
end
