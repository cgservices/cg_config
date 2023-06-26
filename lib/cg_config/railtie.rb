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

    def load_yml_from_path(path)
      Dir.glob(path + '/*.yml') do |yml_file|
        yml_config = YAML.safe_load(ERB.new(File.read(yml_file)).result)
        env_config = yml_config.has_key?(Rails.env) ? yml_config[Rails.env] : yml_config
        const_name = File.basename(yml_file, ".yml").upcase
        unless Object.const_defined? "CgConfig::#{const_name}"
          CgConfig.const_set(const_name, self.recursive_symbolize_keys(env_config))
        end
      end
    end

    initializer "cg_config_railtie.configure_rails_initialization" do |app|
      CgConfig.const_set('CG_CONFIG_FOLDER', '/config/yml') unless CgConfig.constants.include?('CG_CONFIG_FOLDER')
      # Load yml files from Application
      path = Rails.application.root.to_s + CgConfig::CG_CONFIG_FOLDER
      load_yml_from_path(path)


      # Load yml files from railties
      Rails.application.railties.each do |railtie|
        if railtie.respond_to?(:paths) && (path = railtie.root.to_s + CgConfig::CG_CONFIG_FOLDER)
          load_yml_from_path(path)
        end
      end
    end
  end
end

