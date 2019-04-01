# frozen_string_literal: true
module Resolvme
  module Aws
    module AwsClientOptions
      attr_writer :stub_responses

      # Return an AWS client for the given service id
      # @param [Symbol] Service ID (e.g. :EC2 or :CloudFormation)
      # @param [String] AWS Region (optional)
      def aws_client(service_id, region = nil)
        regional_client_id = "#{region}_#{service_id}"
        regional_clients[regional_client_id] ||= aws_client_instance(service_id, region)
      end

      # @return [Boolean] whether to use stub responses (default: false)
      def stub_responses
        @stub_responses || false
      end

      protected

      # @return [Array] List of AWS clients
      def regional_clients
        @_regional_clients_ ||= {}
      end

      private

      def aws_client_instance(service_id, region)
        client_opts = {region: region, stub_responses: stub_responses, retry_limit: 10}.
            delete_if{|_k,v| v.nil?}
        klass = ::Aws.const_get "::Aws::#{service_id}::Client"
        klass.new(client_opts)
      end
    end
  end
end
