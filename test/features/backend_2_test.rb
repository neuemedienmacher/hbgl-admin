# frozen_string_literal: true

require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Backend 2.0' do
  let(:researcher) { FactoryBot.create :researcher }
  let(:superuser) { FactoryBot.create :super }

  describe 'as logged out user' do
    scenario 'I need to login first' do
      visit root_path

      fill_in 'user_email', with: researcher.email
      fill_in 'user_password', with: 'password'
      click_button 'Log in'

      page.must_have_content 'Erfolgreich angemeldet'
    end
  end

  describe 'as a researcher' do
    before { login_as researcher }
    # TODO: Needs JS tests
  end
end
