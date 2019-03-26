module Resolvme
  module Aws
    module AwsClientOptions

      attr_writer :stub_responses

      def aws_client_instance(service_id, region)
        client_opts = {region: region, stub_responses: stub_responses, retry_limit: 10}.
            delete_if{|_k,v| v.nil?}
        klass = "::Aws::#{service_id}::Client".constantize
        klass.new(client_opts)
      end

      def aws_client(service_id, region)
        regional_client_id = "#{region}_#{service_id}"
        regional_clients[regional_client_id] ||= aws_client_instance(service_id, region)
      end

      # @return [Boolean] whether to use stub responses (default: false)
      def stub_responses
        @stub_responses || false
      end

      protected

      def regional_clients
        @_regional_clients_ ||= {}
      end

    end
  end
end