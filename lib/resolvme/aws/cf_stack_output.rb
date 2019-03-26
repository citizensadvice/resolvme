# frozen_string_literal: true
require "aws-sdk-cloudformation"
require "resolvme/aws/aws_client_options"

module Resolvme
  module Aws
    class CloudformationStackOutput
      include AwsClientOptions

      def get_stack_output(stack_name, name, region = nil)
        stack = aws_client(:CloudFormation, region).describe_stacks(stack_name: stack_name).stacks.first
        raise Error, "Stack #{stack_name} not found" unless stack
        out   = stack.outputs.find { |o| o.output_key == name }
        STDERR.puts("WARNING: Stack output #{stack.stack_name}/#{name} not found") unless out
        out ? out.output_value : ''
      end
    end
  end
end
