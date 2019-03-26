require "resolvme/version"

module Resolvme
  class Error < StandardError; end

  require "resolvme/vault/client"
  require "resolvme/aws/cf_stack_output"
  require "resolvme/aws/acm_cert_arn"

end
