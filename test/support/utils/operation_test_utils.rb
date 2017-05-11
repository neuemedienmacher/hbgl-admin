# frozen_string_literal: true
module OperationTestUtils
  def with_params(params, additional_options)
    current_user = (defined?(user) && user) || users(:researcher)
    [
      params,
      {'current_user' => current_user}.merge(additional_options)
    ]
  end

  def with_document(params, additional_options)
    param_hash = params['"id":'] ? {id: params.match(/"id":"(\d+)"/)[1]}: {}
    [
      param_hash,
      {'document' => params, 'current_user' => user || users(:researcher)}
        .merge(additional_options)
    ]
  end

  def run_operation(operation, params, options = {})
    operation.(*with_params(params, options))
  end

  def run_api_operation(operation, params, options = {})
    operation.(*with_document(params, options))
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

  def operation_must_work(operation, params, options = {})
    assert_result(
      run_operation(operation, params, options)
    )
  end

  def operation_wont_work(operation, params, options = {})
    refute_result(
      run_operation(operation, params, options)
    )
  end

  def api_operation_must_work(operation, params, options = {})
    assert_result(
      run_api_operation(operation, params, options)
    )
  end

  def api_operation_wont_work(operation, params, options = {})
    refute_result(
      run_api_operation(operation, params, options)
    )
  end
end
