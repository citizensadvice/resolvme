# frozen_string_literal: true
require "aws-sdk-acm"

module Resolvme
  module Aws
    # Returns the ARN of the latest issued ACM certificate that matches the
    # given domain name in either its main domain name or one of its
    # alternative names
    class AcmCertificateArn
      # Returns the ARN of the latest issued certificate for the given domain
      # name. Raises an exception if the certificate can't be found on ACM
      #
      # @param domain_name [String] domain name to search
      # @param region [String] AWS region
      # @return [String] certificate ARN
      def acm_arn(domain_name, region = nil)
        fd = filtered_details(domain_name, region)
        raise StandardError, "Couldn't find a valid certificate for #{domain_name}" if fd.empty?
        fd.sort_by(&:issued_at).last.certificate_arn
      end

      private

      # ACM client getter
      # @param client_opts [Hash] AWS client options
      # @return [::Aws::ACM::Client] ACM client
      def acm(client_opts = {})
        @acm ||= ::Aws::ACM::Client.new(client_opts)
      end

      # Retrieves and returns the details of the issued ACM certificates from AWS.
      # @return [Array] list of domain details
      def cert_details(region)
        acm_client_opts = {}
        acm_client_opts[:region] = region if region
        acm(acm_client_opts).list_certificates(certificate_statuses: ["ISSUED"]).certificate_summary_list.map do |cert|
          acm(acm_client_opts).describe_certificate(certificate_arn: cert.certificate_arn).certificate
        end
      end

      # Returns a list of details for certificates matching the given domain
      # (both as main or alternative domain name)
      #
      # @param domain_name [String] domain name to filter
      # @param region [String] AWS region
      # @return [Array] filtered list of domain details
      def filtered_details(domain_name, region)
        cert_details(region).find_all do |cert|
          cert.domain_name == domain_name || cert.subject_alternative_names.include?(domain_name)
        end
      end
    end
  end
end
