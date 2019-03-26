# frozen_string_literal: true
require "resolvme/vault/client"
require "resolvme/aws/cf_stack_output"

def vault(path, key)
  @vault ||= ::Resolvme::Vault::Client.new
  @vault.get_secret(path, key)
end

def cf_stack_output(stack, name)
  @so ||= ::Resolvme::Aws::CloudFormation::StackOutput.new
  @so.get_stack_output(stack, name)
end
