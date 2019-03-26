# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Resolvme::Aws::CloudformationStackOutput do
  it 'resolves template' do
    subject.stub_responses = true
    client = subject.aws_client(:CloudFormation)
    client.stub_responses(
      :describe_stacks, 
      stacks: 
        [
          {
            stack_name: 'foostack',
            stack_status: 'CREATE_COMPLETE',
            creation_time: Time.now.utc,
            outputs: [{ output_key: 'Endpoint', output_value: 'bar' }]
          }
        ]
    )
    expect(subject.get_stack_output('foostack', 'Endpoint')).to eq('bar')
  end
end
