# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::ContactPerson::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::ContactPerson::Representer::Show }

  it 'should generate a display name for the label' do
    record = ContactPerson.new(
      first_name: 'Foo', last_name: 'Bar', organization_id: 1
    )
    # NOTE: .create! does not work because the object has an id afterwards
    # and the Representer calls .empty? on 1:Fixnum.. FeelsWeirdMan
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal '# Foo Bar (foobar)'
  end
end
