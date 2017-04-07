# frozen_string_literal: true

require 'bundler/setup'
require 'antelopes'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new,
  Minitest::Reporters::MeanTimeReporter.new
]
