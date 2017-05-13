# frozen_string_literal: true

require 'test_helper'

module Antelopes
  class WorkerTest < Minitest::Test
    def test_running_pulled_job_with_instance_method
      @puller = TestPullerWithJob.new
      assert_output(/Job is running #call with foo: bar/) do
        worker.run
      end
    end

    def test_no_error_when_no_job
      @puller = TestPullerWithoutJob.new
      worker.run
    end

    def test_running_with_class_method
      @puller = TestPullerWithClassJob.new
      assert_output(/Job is running .call with foo: bar/) do
        worker.run
      end
    end

    def test_running_without_params
      @puller = TestPullerNoParamJob.new
      assert_output(/Job is running #without_params/) do
        worker.run
      end
    end

    def test_starting_log
      @puller = TestPullerWithJob.new
      assert_output(/Started job qwerty/) do
        worker.run
      end
    end

    def test_finishing_log
      @puller = TestPullerWithJob.new
      assert_output(/Finished job qwerty/) do
        worker.run
      end
    end

    private

    def worker
      @worker ||= Antelopes::Worker.new(puller: @puller)
    end

    class TestPullerWithJob
      def next_todo
        Job.new(
          'job' => Hash[
            'class' => 'Antelopes::WorkerTest::TestJob', 'method' => 'call', 'args' => Hash['foo' => 'bar']
          ],
          'jid' => 'qwerty'
        )
      end
    end

    class TestPullerWithClassJob
      def next_todo
        Job.new(
          'job' => Hash[
            'class' => 'Antelopes::WorkerTest::TestJob', 'class_method' => 'call', 'args' => Hash['foo' => 'bar']
          ],
          'jid' => 'qwerty'
        )
      end
    end

    class TestPullerNoParamJob
      def next_todo
        Job.new(
          'job' => Hash[
            'class' => 'Antelopes::WorkerTest::TestJob', 'method' => 'without_params', 'args' => nil
          ],
          'jid' => 'qwerty'
        )
      end
    end

    class TestPullerWithoutJob
      def next_todo
        nil
      end
    end

    class TestJob
      def call(foo:)
        Logger.new($stdout).info("Job is running #call with foo: #{foo}")
      end

      def self.call(foo:)
        Logger.new($stdout).info("Job is running .call with foo: #{foo}")
      end

      def without_params
        Logger.new($stdout).info('Job is running #without_params')
      end
    end
  end
end
