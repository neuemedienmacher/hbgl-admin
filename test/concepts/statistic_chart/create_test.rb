# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'
# require_relative '../../support/utils/jsonapi_test_utils'

class StatisticChartCreateTest < ActiveSupport::TestCase
  # include JsonapiTestUtils
  include OperationTestUtils

  let(:user) { users(:super) }
  let(:orga) { organizations(:basic) }
  let(:basic_params) do
    {
      title: 'approval',
      starts_at: Time.zone.now,
      ends_at: Time.zone.now + 1.week,
      # klass_name: 'Offer',
      # amount: 42,
      # field_name: 'aasm_state',
      # field_start_value: 'checkup_process',
      # field_end_value: 'approved',
      user_id: 1
    }
  end

  describe '::StatisticChart::Create' do
    it 'must create a StatisticChart given valid data' do
      operation_must_work ::StatisticChart::Create, basic_params
    end

    describe 'validations' do
      it 'must validate title' do
        basic_params[:title] = nil
        operation_wont_work ::StatisticChart::Create, basic_params
      end

      it 'must validate starts_at' do
        basic_params[:starts_at] = nil
        operation_wont_work ::StatisticChart::Create, basic_params
      end

      it 'must validate ends_at' do
        basic_params[:ends_at] = nil
        operation_wont_work ::StatisticChart::Create, basic_params
      end

      it 'must validate starts_at < ends_at' do
        basic_params[:ends_at] = basic_params[:starts_at] - 1.day
        operation_wont_work ::StatisticChart::Create, basic_params
        basic_params[:ends_at] = basic_params[:starts_at]
        operation_wont_work ::StatisticChart::Create, basic_params
        basic_params[:ends_at] = basic_params[:starts_at] + 1.second
        operation_must_work ::StatisticChart::Create, basic_params
      end

      # it 'must validate target_model' do
      #   basic_params[:target_model] = nil
      #   operation_wont_work ::StatisticChart::Create, basic_params
      # end
      #
      # it 'must validate target_count' do
      #   basic_params[:target_count] = nil
      #   operation_wont_work ::StatisticChart::Create, basic_params
      # end
      #
      # it 'must validate target_field_name' do
      #   basic_params[:target_field_name] = nil
      #   operation_wont_work ::StatisticChart::Create, basic_params
      # end
      #
      # it 'must validate target_field_value' do
      #   basic_params[:target_field_value] = nil
      #   operation_wont_work ::StatisticChart::Create, basic_params
      # end
      #
      # it 'must validate user_team_id' do
      #   basic_params[:user_team_id] = nil
      #   operation_wont_work ::StatisticChart::Create, basic_params
      # end
    end
  end
end
