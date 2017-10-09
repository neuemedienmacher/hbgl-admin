# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::ContactPersonTranslation::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::ContactPersonTranslation::Representer::Show }

  it 'contact person Representer label test' do
    object = FactoryGirl.create :contact_person
    result = subject.new(object.translations.first).to_hash
    result['data']['attributes']['label'].must_equal '#1 (de)'
  end
end
