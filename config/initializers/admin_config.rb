module AdminConfig
  CONFIGS = YAML.load_file(Rails.application.root.join('config', 'admin_config.yml'))

  CONFIGS.keys.each do |key|
    define_singleton_method key do
      CONFIGS[key]
    end
  end
end
