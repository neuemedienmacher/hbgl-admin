# frozen_string_literal: true
require 'active_record'

namespace :user do
  desc 'Reset user passwords to "password"'
  task passwords: :environment do
    User.find_each do |user|
      user.password = 'password'
      user.save
    end
    puts "#{User.count} users updated"
  end
end
