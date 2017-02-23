# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::Division::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Division::Representer::Show }

  it 'should provide its fields' do
    record = Division.new name: 'foo', organization_id: 1
    result = subject.new(record).to_hash
    result[:data][:attributes]['label'].must_equal 'foo'
    result[:data][:relationships]['organization'][:data][:id].must_equal '1'
  end
end
