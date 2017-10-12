# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::SplitBase::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::SplitBase::Representer::Show }
  let(:record) { split_bases(:basic) }

  it 'should provide its fields' do
    record.divisions << FactoryGirl.create(:division)
    result = subject.new(record).to_hash
    label = result['data']['attributes']['label']
    label.must_equal 'basicSplitBaseTitle' \
                     ' (id: ' + record.id.to_s + ', D: ' +
                     record.divisions.map(&:display_name).to_s + ', SC: ' +
                     record.solution_category.name.to_s + ')'
  end
end
