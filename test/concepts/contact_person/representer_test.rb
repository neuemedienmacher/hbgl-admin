# frozen_string_literal: true
require_relative '../../test_helper'

class API::V1::ContactPerson::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::ContactPerson::Representer::Show }

  it 'should generate a display name for the label' do
    record = ContactPerson.create!(
      first_name: 'Foo', last_name: 'Bar', organization: organizations(:basic)
    )
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal '#1 Foo Bar (foobar)'
  end
end
