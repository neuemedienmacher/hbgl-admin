# frozen_string_literal: true
require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Backend 2.0' do
  let(:researcher) { FactoryGirl.create :researcher }
  let(:superuser) { FactoryGirl.create :super }

  describe 'as logged out user' do
    scenario 'I need to login first' do
      visit root_path

      page.must_have_content 'Login to'
      fill_in 'user_email', with: researcher.email
      fill_in 'user_password', with: 'password'
      click_button 'Log in'

      page.must_have_content 'Erfolgreich angemeldet'
    end
  end

  describe 'as a researcher' do
    before { login_as researcher }
    scenario 'I can edit an OfferTranslation' do
      skip 'Needs js tests'
      visit root_path

      click_link 'Administration'
      click_link 'OfferTranslation'
    end
  end
end
