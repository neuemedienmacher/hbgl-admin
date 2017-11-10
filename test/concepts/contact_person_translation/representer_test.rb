# frozen_string_literal: true

require_relative '../../test_helper'
module API
  module V1
    class ContactPersonTranslation::RepresenterTest < ActiveSupport::TestCase
      let(:subject) { API::V1::ContactPersonTranslation::Representer::Show }

      it 'contact person Representer label test' do
        object = FactoryGirl.create :contact_person
        translation = object.translations.first
        result = subject.new(translation).to_hash
        result['data']['attributes']['label']
          .must_equal "##{translation.id} (de)"
      end
    end
  end
end
