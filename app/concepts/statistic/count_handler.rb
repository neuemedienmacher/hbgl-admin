# frozen_string_literal: true
# PORO that handles counting up statistics when record-worthy things happen
class Statistic::CountHandler
  # Increase the counter for a specific statistic by 1
  def self.record user, model, field_name, old_value, new_value
    statistic = find_or_initialize(
      user_id: user.id,
      date: Time.zone.now.to_date,
      user_team_id: user.current_team&.id,
      model: model,
      field_name: field_name,
      field_start_value: old_value,
      field_end_value: new_value
    )
    statistic.count += 1
    statistic.save!
  end

  def self.find_or_initialize properties
    Statistic.where(properties).first || Statistic.new(properties)
  end
end
