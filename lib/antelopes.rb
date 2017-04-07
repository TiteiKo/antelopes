# frozen_string_literal: true

require 'serverengine'

# Nice and smart background jobs.
#
# @since x.x.x
module Antelopes
  def self.start
    ::ServerEngine.create(Master, Looper, configuration).run
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

require 'antelopes/master'
require 'antelopes/looper'
require 'antelopes/worker'
require 'antelopes/job'
