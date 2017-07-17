# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::PossibleEvents::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::PossibleEvents::Show }

  it 'should return possible events for an initialized organization' do
    organization = organizations(:basic)
    organization.aasm_state = 'initialized'
    result = subject.new(organization).to_hash
    result['data'].must_equal [:complete, :website_under_construction]
  end

  it 'should return possible events for an approved offer' do
    result = subject.new(offers(:basic)).to_hash
    result['data'].must_equal [
      :expire, :deactivate_internal, :deactivate_external,
      :website_under_construction, :start_checkup_process
    ]
  end

  it 'should return possible events for a Division' do
    division = FactoryGirl.create :division
    result = subject.new(division).to_hash
    result['data'].must_equal [:mark_as_done]
  end

  it 'should return an empty array for any other model' do
    result = subject.new(locations(:basic)).to_hash
    result['data'].must_equal []
  end
end
