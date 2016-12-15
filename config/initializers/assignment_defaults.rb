template = ERB.new File.new(Rails.application.root.join('config', 'assignments.yml.erb')).read
defaults = YAML.load(template.result(binding))[Rails.env]
AssignmentDefaults = OpenStruct.new(defaults)
