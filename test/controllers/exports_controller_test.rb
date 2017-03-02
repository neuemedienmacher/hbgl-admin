# frozen_string_literal: true
require_relative '../test_helper'

describe ExportsController do
  describe "POST 'create'" do
    let(:working_export_hash) do
      { model_fields: %w(id name), section_filters: ['id'] }
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

      it 'should include a dash for nil-association' do
        # parent on categories can be nil
        export_hash = { model_fields: %w(id name_de), parent: ['id'] }
        result = Export::Create.(
          { object_name: 'categories', export: export_hash },
          'current_user' => users(:researcher)
        )
        result.must_be :success?
        enum = @controller.send(:csv_lines, result['model'])
        enum.next
        enum.to_a.must_equal [
          "id,name_de,id [Parent]\n",
          "1,main1, - \n",
          "2,main2, - \n",
          "3,sub1.1,1\n",
          "4,sub1.2,1\n"
        ]
      end
    end
  end
end
