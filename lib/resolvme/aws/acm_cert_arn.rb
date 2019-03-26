# frozen_string_literal: true
require "aws-sdk-acm"
require "resolvme/aws/aws_client_options"

module Resolvme
  module Aws
    # Returns the ARN of the latest issued ACM certificate that matches the
    # given domain name in either its main domain name or one of its
    # alternative names
    class AcmCertificateArn
      include AwsClientOptions

      # Returns the ARN of the latest issued certificate for the given domain
      # name. Raises an exception if the certificate can't be found on ACM
      #
      # @param domain_name [String] domain name to search
      # @param region [String] AWS region
      # @return [String] certificate ARN
      def acm_arn(domain_name, region = nil)
        fd = filtered_details(domain_name, region)
        raise ResolvmeError, "Couldn't find a valid certificate for #{domain_name}" if fd.empty?
        fd.sort_by(&:issued_at).last.certificate_arn
      end

      private

      # Retrieves and returns the details of the issued ACM certificates from AWS.
      # @return [Array] list of domain details
      def cert_details(region)
        acm = aws_client(:ACM, region)
        acm.list_certificates(certificate_statuses: ["ISSUED"]).certificate_summary_list.map do |cert|
          acm.describe_certificate(certificate_arn: cert.certificate_arn).certificate
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
