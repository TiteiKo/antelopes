# frozen_string_literal: true

module Antelopes
  # Job object representation
  #
  # @since 0.0.1
  class Job
    # @!attribute [r] jid
    #   @return [String] the uuid of the job
    # @!attribute [r] job_class
    #   @return [String] the class name of the job to run
    # @!attribute [r] job_method
    #   @return [Symbol] the instance method to execute. nil if job_class_method is set
    # @!attribute [r] job_class_method
    #   @return [Symbol] the class method to execute. nil if job_method is set
    # @!attribute [r] job_args
    #   @return [Hash] arguments for the job (class) method
    attr_reader :jid, :job_class, :job_method, :job_class_method, :job_args

    # Initialization from json hash
    #
    # @param json_payload [Hash] deserialized JSON hash
    # @return [Job] a Job
    # @since 0.0.1
    def initialize(json_payload)
      @jid = json_payload['jid']
      setup_job_attrs(json_payload['job'])
    end

    # Format to string
    #
    # @return [String] the job formatted in string
    # @since x.x.x
    def to_s
      inspect
    end

    private

    def setup_job_attrs(json_payload)
      @job_class = json_payload['class']
      @job_method = json_payload['method']&.to_sym
      @job_class_method = json_payload['class_method']&.to_sym
      setup_job_args(json_payload['args'])
    end

    def setup_job_args(args)
      return if args.nil?

      @job_args = Hash[args.map { |k, v| [k.to_sym, v] }]
    end
  end
end
