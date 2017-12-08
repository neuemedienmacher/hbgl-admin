# frozen_string_literal: true

FactoryBot.define do
  factory :opening do
    day { Opening.enumerized_attributes.attributes['day'].values.sample }
    open { rand(0.0..24.0).hours.from_now }
    close { open + rand(0.0..3.0).hours }
    name do
      if day && open && close
        "#{day.titleize} #{open}-#{close}"
      elsif day
        "#{day.titleize} (appointment)"
      end
    end
    sort_value { rand(1..4) }
  end
end
