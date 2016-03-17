require 'test_helper'

class OfferConceptTest < Cell::TestCase
  test "show" do
    html = concept("offer/cell").(:show)
    assert html.match(/<p>/)
  end
end
