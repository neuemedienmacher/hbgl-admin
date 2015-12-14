### SimpleCOV ###
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

def reenable_http
  Net::HTTP.test_enabled = true
end
