# frozen_string_literal: true
require "aws-sdk-cloudformation"

module Resolvme
  module Aws
    module CloudFormation
      class StackOutput
        def client
          @client ||= ::Aws::CloudFormation::Client.new
        end

        def get_stack_output(stack, name)
          stack = client.describe_stacks(stack_name: stack).stacks.first
          out = stack.outputs.find {|o| o.output_key == name}
          STDERR.puts("WARNING: Stack output #{stack.stack_name}/#{name} not found") unless out
          out ? out.output_value : ''
        end
      end
    end
  end
end
