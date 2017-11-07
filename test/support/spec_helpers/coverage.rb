### SimpleCOV ###
require 'coveralls'
require 'simplecov'

class SimpleCov::Formatter::MergedFormatter
  def format(result)
     SimpleCov::Formatter::HTMLFormatter.new.format(result)
     Coveralls::SimpleCov::Formatter.new.format(result)
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter

# Coveralls.wear!('rails')
