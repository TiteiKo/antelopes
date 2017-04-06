# frozen_string_literal: true

require 'test_helper'

describe Antelopes::Worker do
  describe 'pulling job' do
    let(:worker) { Antelopes::Worker.new }

    it 'works' do
      assert_output(/Worker is working!/) do
        worker.run
      end
    end
  end
end
