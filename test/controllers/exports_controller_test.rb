# frozen_string_literal: true
require_relative '../test_helper'

describe ExportsController do
  describe "POST 'create'" do
    let(:working_export_hash) do
      { model_fields: ['id', 'name'],  section_filters: ['id'] }
    end
    let(:user) { users(:researcher) }

    it 'should start a streaming export' do
      sign_in user
      post :create, object_name: 'cities', export: working_export_hash
      assert_response :success
      response.header['Content-Type'].must_equal 'text/csv'
      response.header['Content-disposition'].must_include 'attachment;'
    end

    it 'should render an error when an invalid request is issued' do
      sign_in user
      post :create, object_name: 'cities', export: {
        model_fields: [:doesntexist]
      }
      assert_response 403
      response.body.must_equal 'error'
    end

    describe 'private #csv_line' do # because tests don't stream
      it 'should include a header and the correct body' do
        result = Export::Create.(
          { object_name: 'cities', export: working_export_hash },
          'current_user' => users(:researcher)
        )
        result.must_be :success?
        enum = @controller.send(:csv_lines, result['model'])
        enum.next
        enum.to_a.must_equal [
          "id,name,id [Section Filters]\n", "1,Berlin,8\n"
        ]
      end
    end
  end
end
