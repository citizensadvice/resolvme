# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Resolvme::Aws::CloudformationStackOutput do
  it 'has a version number' do
    expect(Resolvme::VERSION).not_to be nil
  end

  it 'resolves template' do
    subject.stub_responses = true
    subject.aws_client(:CloudFormation)
           .stub_responses(:describe_stacks, stacks: [
                             {
                               stack_name: 'foostack',
                               stack_status: 'CREATE_COMPLETE',
                               creation_time: Time.now.utc,
                               outputs: [{ output_key: 'Endpoint', output_value: 'bar' }]
                             }
                           ])
    expect(subject.get_stack_output('foostack', 'Endpoint')).to eq('bar')
  end
end
