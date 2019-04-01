# frozen_string_literal: true
require "aws-sdk-cloudformation"
require "resolvme/aws/aws_client_options"

module Resolvme
  module Aws
    class CloudformationStackOutput
      include AwsClientOptions

      # Returns a single stack output.
      #
      # @param stack_name [String] The stack name
      # @param output_key [String] The output name
      # @param region [String] AwS region
      # @return [String] The output value
      def get_stack_output(stack_name, output_key, region = nil)
        output = get_stack_outputs(stack_name, region).find { |o| o.output_key == output_key }
        raise ResolvmeError, "Stack output #{stack_name}/#{output_key} not found" unless output
        output.output_value
      end

      # Returns a list of outputs for a stack.
      #
      # @param stack_name [String] The stack name
      # @param output_key [String] The output name
      # @param region [String] AwS region
      # @return [Array<Aws::CloudFormation::Types::Output>] Stack outputs
      def get_stack_outputs(stack_name, stack_region = nil)
        stack = aws_client(:CloudFormation, stack_region).describe_stacks(stack_name: stack_name).stacks.first
        raise ResolvmeError, "Stack #{stack_name} not found" unless stack
        stack.outputs
      end

    end
  end
end
