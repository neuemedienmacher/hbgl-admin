# frozen_string_literal: true
class User::Twin < Disposable::Twin
  collection :user_teams

  def presumed_section
    valid_sections = ::Section::IDENTIFIER
    user_teams.pluck(:classification).find { |i| valid_sections.include?(i) }
  end
end
