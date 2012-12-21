# Loop through CG_CONFIG_FOLDER to to load all yml files into constants
puts "Loading yml config files..."

module CgConfig
  CG_CONFIG_FOLDER ||= "#{Rails.root}/config/cg"
end

Dir.glob("#{CgConfig::CG_CONFIG_FOLDER}/*.yml") do |yml_file|
  yml_config = YAML.load_file(yml_file)
  env_config = config.has_key? Rails.env ? yml_config[Rails.env] : yml_config

  CgConfig.const_set(File.basename(rb_file, ".yml").upcase, env_config.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo})
end

