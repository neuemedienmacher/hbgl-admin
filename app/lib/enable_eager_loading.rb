# frozen_string_literal: true
# NOTE make pg_search work with our association filters
# see: https://github.com/Casecommons/pg_search/issues/330
# may re-introduce this bug: https://github.com/Casecommons/pg_search/issues/14
module EnableEagerLoading
  def eager_loading?
    true
  end
end
