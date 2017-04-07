# frozen_string_literal: true

require 'test_helper'

module Antelopes
  class JobTest < Minitest::Test
    def test_without_override_of_call
      assert_raises NotImplementedError do
        TestJobWithoutCall.new.call
      end
    end

    def test_call_runs_the_method
      assert_equal 'Hello world', TestJob.new.call('world')
    end

    class TestJobWithoutCall
      include Antelopes::Job
    end

    class TestJob
      include Antelopes::Job

      def call(world)
        "Hello #{world}"
      end
    end
  end
end
