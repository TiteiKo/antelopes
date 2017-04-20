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

    private

    def worker
      @worker ||= Antelopes::Worker.new(puller: @puller)
    end

    class TestPullerWithJob
      def pull
        Job.new(
          'job' => Hash['class' => 'Antelopes::WorkerTest::TestJob', 'method' => 'call', 'args' => Hash['foo' => 'bar']],
          'jid' => 'qwerty'
        )
      end
    end

    class TestPullerWithClassJob
      def pull
        Job.new(
          'job' => Hash['class' => 'Antelopes::WorkerTest::TestJob', 'class_method' => 'call', 'args' => Hash['foo' => 'bar']],
          'jid' => 'qwerty'
        )
      end
    end

    class TestPullerWithoutJob
      def pull
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
    end
  end
end
