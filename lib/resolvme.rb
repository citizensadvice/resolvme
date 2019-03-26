class ResolvmeError < StandardError;
end

require "resolvme/vault/client"
require "resolvme/aws/cf_stack_output"
require "resolvme/aws/acm_cert_arn"

def vault(path, key)
  @vault ||= ::Resolvme::Vault::Client.new
  @vault.get_secret(path, key)
end

def cf_stack_output(stack, name, region = nil)
  @so ||= ::Resolvme::Aws::CloudformationStackOutput.new
  @so.get_stack_output(stack, name, region)
end

def acm_cert_arn(domain, region = nil)
  acm = ::Resolvme::Aws::AcmCertificateArn.new
  acm.acm_arn(domain, region)
end
