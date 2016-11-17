defaults = YAML.load_file(Rails.application.root.join('config', 'assignments.yml'))[Rails.env]
AssignmentDefaults = OpenStruct.new(defaults)
