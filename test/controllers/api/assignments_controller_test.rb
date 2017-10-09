# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/api_controller_test_utils'

describe API::V1::AssignmentsController do
  include API::ControllerTestUtils
  let(:user) { users(:researcher) }

  it '#index should respond to jsonapi requests' do
    api_get_works_for :index
  end

  it '#show should respond to jsonapi requests' do
    api_get_works_for :show, id: 1
  end

  describe '#create' do
    it 'should handle an incomplete create request' do
      sign_in user
      create_fails_with Assignment, foo: 'foo'
      response.body.must_include 'muss ausgefüllt werden' # ie
      response.body.must_include '/data/attributes/assignable-type'
    end

    it 'should successfully handle a create request' do
      sign_in user
      create_works_with Assignment, assignable_id: OfferTranslation.last.id,
                                    assignable_type: 'OfferTranslation',
                                    receiver_id: users(:super),
                                    message: 'Foorem Ipsbar'

      assignment = Assignment.last
      assignment.message.must_equal 'Foorem Ipsbar'
      assignment.creator.must_equal user
    end
  end

  # describe '#update' do
  #   it 'should successfully handle an update request' do
  #     update_works_with Assignment, id: 1, message: 'bar!'
  #     Assignment.find(1).message.must_equal 'bar'
  #   end
  # end
end
