# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::Contact::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::Contact::Representer::Show }

  it 'should provide its fields' do
    record = Contact.create!(name: 'bla', email: 'bla@bla.com',
                             url: 'www.bla.com', message: 'bla')
    result = subject.new(record).to_hash
    result['data']['attributes']['label'].must_equal 'bla'
  end
end
