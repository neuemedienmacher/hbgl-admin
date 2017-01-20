# require_relative '../test_helper'
#
# class EditTranslationTest < AcceptanceTest
#   let(:admin) { User.where(role: 'super').first }
#   before { login_as admin }
#
#   it 'must contain translation content and important links', js: true do
#     translation = OfferTranslation.first
#
#     visit "/offer_translations/#{translation.id}/edit"
#
#     page.must_have_content 'basicOfferName'
#     page.must_have_content 'DE=>basicOfferDescription'
#     page.must_have_content 'Original'
#     page.must_have_content '(Preview)'
#   end
# end
