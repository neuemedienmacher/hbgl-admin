# frozen_string_literal: true
module OperationTestUtil
  def with_params(params, user = nil)
    [params, {'current_user' => user || users(:researcher)}]
  end

  def with_document(params, user = nil)
    [{}, {'document' => params, 'current_user' => user || users(:researcher)}]
  end

  def run_operation(operation, params)
    operation.(*with_params(params))
  end

  def run_api_operation(operation, params)
    operation.(*with_document(params))
  end

  def assert_result(result)
    result.must_be :success?
    result['model'].must_be :persisted?
    result
  end

  def refute_result(result)
    result.must_be :failure?
    result
  end

  def operation_must_work(operation, params)
    assert_result(
      run_operation(operation, params)
    )
  end

  def operation_wont_work(operation, params)
    refute_result(
      run_operation(operation, params)
    )
  end

  def api_operation_must_work(operation, params)
    assert_result(
      run_api_operation(operation, params)
    )
  end

  def api_operation_wont_work(operation, params)
    refute_result(
      run_api_operation(operation, params)
    )
  end

  def to_jsonapi(param_hash, type)
    {
      data: {
        type: type,
        attributes: basic_params
      }
    }.to_json
  end
end
