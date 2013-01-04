# Loop through CgConfig::CG_CONFIG_FOLDER to to load all yml files into constants
module CgConfig
  class CgConfigRailtie < Rails::Railtie
    def recursive_symbolize_keys(h)
      case h
        when Hash
          Hash[
              h.map do |k, v|
                [ k.respond_to?(:to_sym) ? k.to_sym : k, recursive_symbolize_keys(v) ]
              end
          ]
        when Enumerable
          h.map { |v| recursive_symbolize_keys(v) }
        else
          h
      end
    end

    initializer "cg_config_railtie.configure_rails_initialization" do |app|
      CgConfig.const_set('CG_CONFIG_FOLDER', '/config/yml') unless CgConfig.constants.include?('CG_CONFIG_FOLDER')

      puts "Loading yml config files from #{app.root}#{CgConfig::CG_CONFIG_FOLDER}..."
      Dir.glob("#{app.root}/#{CgConfig::CG_CONFIG_FOLDER}/*.yml") do |yml_file|

        yml_config = YAML.load_file(yml_file)
        env_config = yml_config.has_key?(Rails.env) ? yml_config[Rails.env] : yml_config
        const_name = File.basename(yml_file, ".yml").upcase

        puts "Setting #{const_name}"

        CgConfig.const_set(const_name, self.recursive_symbolize_keys(env_config))
      end
    end
  end
end

