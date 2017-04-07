# frozen_string_literal: true

require 'test_helper'

describe Antelopes::Job do
  let(:job_class) do
    Class.new
  end

  before do
    job_class.include(Antelopes::Job)
  end

  describe 'without overriding #call' do
    it 'raises an error' do
      assert_raises NotImplementedError do
        job_class.new.call
      end
    end
  end

  describe 'with the method overriden' do
    before do
      def job_class.call(world)
        "Hello #{world}"
      end
    end

    it 'runs the method' do
      assert_equal 'Hello world', job_class.call('world')
    end
  end
end
