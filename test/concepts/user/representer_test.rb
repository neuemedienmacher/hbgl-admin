# frozen_string_literal: true

require_relative '../../test_helper'

class API::V1::User::RepresenterTest < ActiveSupport::TestCase
  let(:subject) { API::V1::User::Representer::Update }

  it 'should generate a generic label for a model without a name' do
    record = User.create!(
      user_team_ids: UserTeam.first.id, name: 'Nutzer', email: 'abc@bcd.de',
      password: SecureRandom.base64, role: 'researcher'
    )
    UserTeam.last.update(lead_id: record.id)
    result = subject.new(record).to_hash
    result['included'].first['attributes']['label']
                      .must_equal UserTeam.first.name
    result['included'].second['attributes']['label']
                      .must_equal UserTeam.last.name
  end
end
