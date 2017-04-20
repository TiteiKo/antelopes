# frozen_string_literal: true

require 'serverengine'
require 'connection_pool'
require 'redis'
require 'securerandom'
require 'json'

# Nice and smart background jobs.
#
# @since x.x.x
module Antelopes
  # Method to call to start the workers
  #
  # @since x.x.x
  def self.start
    ::ServerEngine.create(Master, Looper, configuration).run
  end

  # Method to add a job to queue.
  #
  # @example Instance method call
  #   Antelopes.push('MyClass', method: :call, args: Hash[foo: 'bar'])
  #   # The worker will run the following code:
  #   MyClass.new.call(foo: 'bar')
  #
  # @example Class method call
  #   Antelopes.push('MyClass', class_method: :call, args: Hash[foo: 'bar'])
  #   # The worker will run the following code:
  #   MyClass.call(foo: 'bar')
  #
  # @param job_class [String] class of the job to perform
  # @param method [Symbol] public method of the instance to call
  # @param class_method [Symbol] public method of the class to call
  # @param args [Hash] parameters for the method
  #
  # @since x.x.x
  def self.push(job_class, method: nil, class_method: nil, args: Hash[])
    Pusher.new.call(class: job_class, method: method, class_method: class_method, args: args)
  end

  # Loopers configuration to pass to ServerEngine
  #
  # @since x.x.x
  # @todo Make it configurable via a configuration file or environment variables
  def self.configuration
    Hash[
      worker_type:   'thread',
      workers:       4,
      supervisor:    true,
      enable_detach: true,
      log:           'myserver.log',
      pid_path:      'myserver.pid'
    ]
  end
end

require 'antelopes/redis'

require 'antelopes/master'
require 'antelopes/looper'
require 'antelopes/worker'
require 'antelopes/job'

require 'antelopes/pusher'
require 'antelopes/puller'
