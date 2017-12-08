# encoding: UTF-8
# frozen_string_literal: true

require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Admin Backend' do
  let(:researcher) { FactoryBot.create :researcher }
  let(:superuser) { FactoryBot.create :super }

  describe 'as researcher' do
    before { login_as researcher }

    scenario 'Duplicate contact_person' do
      FactoryBot.create :contact_person, spoc: true, offers: [offers(:basic)]

      visit rails_admin_path
      click_link 'Kontaktpersonen', match: :first
      click_link 'Duplizieren', match: :first
      click_button 'Speichern'
      page.wont_have_content 'Kontaktperson wurde nicht hinzugefügt'
      page.must_have_content 'Kontaktperson wurde erfolgreich hinzugefügt'
    end
  end
end
