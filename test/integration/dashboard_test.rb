require_relative '../test_helper'

class DashboardTest < AcceptanceTest
  let(:admin) { User.where(role: 'super').first }
  before { login_as admin }

  it 'should correctly display the dashboard', js: true do

    user = User.where(role: 'super').first

    visit '/admin'

    page.must_have_content 'Backend 2.0 (Beta)'
    click_link 'Backend 2.0 (Beta)'

    # page.must_have_content 'Dashboard'
    page.must_have_content "Willkommen, #{user.name}"
    page.must_have_content 'Ich arbeite gerade für das Team'
    page.must_have_content 'Deinem aktuellen Team zugewiesene, offene Aufgaben:'

    click_link 'Meine Aufgaben'
    page.must_have_content 'Dir zugewiesene, offene Aufgaben:'

    click_link 'Abgeschlossene Aufgaben'
    page.must_have_content 'Von dir empfangene, abgeschlossene Aufgaben:'
  end
end
