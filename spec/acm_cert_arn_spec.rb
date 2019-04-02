# frozen_string_literal: true

RSpec.describe Resolvme::Aws::AcmCertificateArn do
  subject do
    s                = Resolvme::Aws::AcmCertificateArn.new
    s.stub_responses = true
    s.aws_client(:ACM).stub_responses(
      :list_certificates,
      certificate_summary_list:
        [
          {
            certificate_arn: "arn:aws:acm:eu-west-1:123456789012:certificate/12345678-1234-1234-1234-123456789012",
            domain_name:     "myapp.com"
          },
          {
            certificate_arn: "arn:aws:acm:eu-west-1:123456789012:certificate/22222222-2222-2222-2222-222222222222",
            domain_name:     "myapp.com"
          },
          {
            certificate_arn: "arn:aws:acm:eu-west-1:123456789012:certificate/33333333-3333-3333-3333-333333333333",
            domain_name:     "myapp.com"
          }
        ]
    )
    s
  end

  describe "locating certificates" do
    let(:expected_response) do
      {
        certificate_arn:           "arn:aws:acm:eu-west-1:123456789012:certificate/12345678-1234-1234-1234-123456789012",
        domain_name:               "myapp.com",
        issued_at:                 Time.parse("2019-04-02 11:46:25"),
        subject_alternative_names: %w[*.myapp.com *.app.com]
      }
    end

    it "locate certificate for domain" do
      subject.aws_client(:ACM).stub_responses(
        :describe_certificate,
        certificate:
          {
            certificate_arn:           "arn:aws:acm:eu-west-1:123456789012:certificate/12345678-1234-1234-1234-123456789012",
            domain_name:               "myapp.com",
            issued_at:                 Time.parse("2019-04-02 11:46:25"),
            subject_alternative_names: %w[*.myapp.com *.app.com]
          }
      )
      expect(subject.domain_certificates("app.com", nil).first.to_h).to eq(expected_response)
      expect(subject.domain_certificates("*.app.com", nil).first.to_h).to eq(expected_response)
      expect(subject.domain_certificates("myapp.com", nil).first.to_h).to eq(expected_response)
      expect(subject.domain_certificates("*.myapp.com", nil).first.to_h).to eq(expected_response)
      expect(subject.domain_certificates("*.myapp.com", nil).first.to_h).to eq(expected_response)
      expect(subject.domain_certificates("*.myapp.com", nil).first.to_h).to eq(expected_response)
    end

  end
end
