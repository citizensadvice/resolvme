# frozen_string_literal: true
module Resolvme
  require "resolvme/vault/client"
  require "resolvme/aws/cf_stack_output"
  require "resolvme/aws/acm_cert_arn"

  class Context
    class << self
      # Wrapper for {::Resolvme::Vault::Client#get_secret}
      def vault(path, key)
        @vault ||= ::Resolvme::Vault::Client.new
        @vault.read_secret_field(path, key)
      end

      # Wrapper for {::Resolvme::Aws::CloudformationStackOutput#get_stack_output}
      def cf_stack_output(stack, name, region = nil)
        @so ||= ::Resolvme::Aws::CloudformationStackOutput.new
        @so.get_stack_output(stack, name, region)
      end

      # Wrapper for {::Resolvme::Aws::AcmCertificateArn#acm_arn}
      def acm_cert_arn(domain, region = nil)
        acm = ::Resolvme::Aws::AcmCertificateArn.new
        acm.acm_arn(domain, region)
      end

      # Expose bindings to be used by ERB or other programs
      def get_binding
        binding
      end
    end
  end
end
