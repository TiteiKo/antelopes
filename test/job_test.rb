# frozen_string_literal: true

require 'test_helper'

module Antelopes
  class JobTest < Minitest::Test
    def test_args_deserialization
      assert_equal Hash[foo: 'bar'], Job.new(Hash['job' => Hash['args' => Hash['foo' => 'bar']]]).job_args
    end
  end
end
