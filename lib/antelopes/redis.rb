# frozen_string_literal: true

module Antelopes
  # Class used to generate a Redis connection
  #
  # @since x.x.x
  class Redis
    def connection
      ::Redis.new
    end
  end
end
