# frozen_string_literal: true

require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.libs << 'test'
  t.warning = false
end

task default: :test
