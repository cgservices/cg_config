# Loop through CgConfig::CG_CONFIG_FOLDER to to load all yml files into constants
module CgConfig
  class CgConfigRailtie < Rails::Railtie
    initializer "cg_config_railtie.configure_rails_initialization" do |app|
      CgConfig.const_set('CG_CONFIG_FOLDER', '/config/yml') unless CgConfig.constants.include?('CG_CONFIG_FOLDER')

      puts "Loading yml config files from #{app.root}/#{CgConfig::CG_CONFIG_FOLDER}..."
      Dir.glob("#{app.root}/#{CgConfig::CG_CONFIG_FOLDER}/*.yml") do |yml_file|

        yml_config = YAML.load_file(yml_file)
        env_config = yml_config.has_key?(Rails.env) ? yml_config[Rails.env] : yml_config
        const_name = File.basename(yml_file, ".yml").upcase

        puts "Setting #{const_name}"

        CgConfig.const_set(const_name, env_config.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo})
      end
    end
  end
end

