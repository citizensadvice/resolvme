# frozen_string_literal: true
require "aws-sdk-acm"
require "resolvme/error"
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
        certs = domain_certificates(domain_name, region)
        raise ResolvmeError, "Couldn't find a valid certificate for #{domain_name}" if certs.empty?
        certs.sort_by(&:issued_at).last.certificate_arn
      end

      # Retrieves and returns the details of the issued ACM certificates from AWS.
      # @return [Array] list of domain details
      def acm_certificates(region)
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
      def domain_certificates(domain_name, region)
        acm_certificates(region).find_all do |cert|
          cert.domain_name == domain_name ||
            cert.domain_name == ("*." + domain_name) ||
            cert.subject_alternative_names.include?(domain_name) ||
            cert.subject_alternative_names.include?("*." + domain_name)
        end
      end
    end
  end
end
