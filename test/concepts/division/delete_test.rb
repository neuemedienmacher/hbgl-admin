# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

class DivisionDeleteTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:division) { divisions(:basic) }
  let(:basic_params) { { id: division.id } }

  describe '::Division::Delete' do
    it 'must delete a Division when there are no dependent offers' do
      division.offers.delete_all
      run_operation ::Division::Delete, basic_params,
                    model_class: ::Division
      assert_raises(ActiveRecord::RecordNotFound) { division.reload }
    end

    it 'must not delete a Division when there are dependent offers' do
      run_operation ::Division::Delete, basic_params,
                    model_class: ::Division
      refute_nil division
    end

    it 'must set sync orga state when division gets deleted' do
      orga = Organization.find division.organization_id
      orga.update_columns(aasm_state: 'approved')
      division.offers.delete_all
      run_operation ::Division::Delete, basic_params,
                    model_class: ::Division
      assert orga.aasm_state = 'all_done'
    end
  end
end
