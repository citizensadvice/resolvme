# frozen_string_literal: true
require_relative "aws_client_options"
require "aws-sdk-cloudformation"

module Resolvme
  module Aws
    module CloudFormation
      class StackOutput
        include AwsClientOptions

        def get_stack_output(stack, name, region = nil)
          stack = aws_client(:CloudFormation, region).describe_stacks(stack_name: stack).stacks.first
          out = stack.outputs.find {|o| o.output_key == name}
          STDERR.puts("WARNING: Stack output #{stack.stack_name}/#{name} not found") unless out
          out ? out.output_value : ''
        end
      end
    end
  end
end