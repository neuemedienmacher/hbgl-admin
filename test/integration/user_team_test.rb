require_relative '../test_helper'

class UserTeamTest < AcceptanceTest
  let(:admin) { User.where(role: 'super').first }
  before { login_as admin }

  it 'should correctly show an existing user team', js: true do
    visit "/user_teams/1"

    page.must_have_content "user_team#1"
    page.must_have_content 'Eigene Felder'
    page.must_have_content 'id'
    page.must_have_content 'name'
    page.must_have_content 'classification'
    page.must_have_content 'Verknüpfte Modelle'
    page.must_have_content 'users'
  end

  it 'should correctly create a new team', js: true do
    visit "/user_teams/new"

    page.must_have_content 'Team anlegen'
    page.must_have_content 'name'
    page.must_have_content 'user_ids'

    fill_in 'user_team[name]', with: 'EpicNewTeam'
    # TODO: how to access this field?!
    # fill_in 'user_team[user_ids]', with: 'superName'

    click_button 'Abschicken'

    UserTeam.last.name.must_equal 'EpicNewTeam'
  end
end
