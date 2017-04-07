# frozen_string_literal: true

module Antelopes
  # Job module to be included in all jobs.
  #
  # @since x.x.x
  module Job
    # Method called by the worker, this is where you should put
    # the code actually doing something.
    #
    # @since x.x.x
    # @raise [NotImplementedError] unless the method is overide
    def call(**_)
      raise NotImplementedError
    end
  end
end
