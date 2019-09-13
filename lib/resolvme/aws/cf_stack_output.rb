# frozen_string_literal: true
require "aws-sdk-cloudformation"
require "resolvme/error"
require "resolvme/aws/aws_client_options"

module Resolvme
  module Aws
    class CloudformationStackOutput
      include AwsClientOptions

      class OutputNotFoundError < ResolvmeError; end

      # Initialize the object instance
      # @param region [String] AWS region
      # @return [Resolvme::Aws::CloudformationStackOutput]
      def initialize(region = nil)
        @cache = {}
        @region = region
      end

      # Returns a single stack output.
      #
      # @param stack_name [String] The stack name
      # @param output_key [String] The output name
      # @return [String] The output value
      def get_stack_output(stack_name, output_key)
        output = get_stack_outputs(stack_name).find { |o| o.output_key == output_key }
        raise OutputNotFoundError, "Stack output #{stack_name}/#{output_key} not found" unless output
        output.output_value
      end

      # Returns a list of outputs for a stack.
      # Maintains a local cache to avoid redundant API requests.
      #
      # @param stack_name [String] The stack name
      # @param output_key [String] The output name
      # @return [Array<Aws::CloudFormation::Types::Output>] Stack outputs
      def get_stack_outputs(stack_name)
        @cache[stack_name] ||= aws_client(:CloudFormation, @region).describe_stacks(stack_name: stack_name).stacks.first.outputs
      end
    end
  end
end
