# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class DivisionCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:researcher) }
  let(:orga) { organizations(:basic) }
  let(:basic_params) do
    {
      addition: 'DivisionAddition',
      description: 'DivisionDescription',
      organization: orga,
      section: orga.sections.first,
      city: orga.locations.first.city
    }
  end

  describe '::Division::Create' do
    it 'must create a Division given valid data' do
      operation_must_work ::Division::Create, basic_params
    end

    it 'must create a division with presumed (solution) categories and label' do
      tag1 = FactoryGirl.create(:tag)
      tag2 = FactoryGirl.create(:tag)

      params = basic_params.merge(
        presumed_tags: [{ id: tag1.id }, { id: tag2.id }],
        presumed_solution_categories: [{ id: 1 }]
      )
      result = operation_must_work ::Division::Create, params
      result['model'].presumed_tags.count.must_equal 2
      result['model'].presumed_tags.first.id.must_equal tag1.id
      result['model'].presumed_tags.last.id.must_equal tag2.id
      result['model'].presumed_solution_categories.count.must_equal 1
      result['model'].presumed_solution_categories.first.id.must_equal 1
      result['model'].label.must_equal(
        'foobar (family), City: Berlin, Addition: DivisionAddition'
      )
    end

    it 'must create a division without an addition' do
      basic_params[:addition] = nil
      result = operation_must_work ::Division::Create, basic_params
      result['model'].label.must_equal('foobar (family), City: Berlin')
    end

    describe 'validations' do
      it 'must validate organization' do
        basic_params[:organization] = nil
        operation_wont_work ::Division::Create, basic_params
      end

      it 'must validate section' do
        basic_params[:section] = nil
        operation_wont_work ::Division::Create, basic_params
      end
    end

    describe 'side-effects' do
      describe '#SyncOrganization' do
        it 'created division must not be done it should reset'\
        ' orga to approved' do
          orga.aasm_state.must_equal 'all_done'
          operation_must_work ::Division::Create, basic_params,
                              current_user: user
          orga.reload.aasm_state.must_equal 'approved'
        end

        it 'should not change the Orga-state when it is not all_done' do
          orga.update_columns aasm_state: 'completed'
          operation_must_work ::Division::Create, basic_params,
                              current_user: user
          orga.reload.aasm_state.must_equal 'completed'
        end
      end
    end
  end
end
