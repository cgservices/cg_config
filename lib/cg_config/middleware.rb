module CgConfig
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      CgConfig.const_set('CG_CONFIG_FOLDER', '/config/yml') unless CgConfig.constants.include?('CG_CONFIG_FOLDER')
      Rails.application.railties.each do |railtie|
        if railtie.respond_to?(:paths) && (path = railtie.root.to_s + CgConfig::CG_CONFIG_FOLDER)
          Dir.glob(path + '/*.yml') do |yml_file|
            yml_config = YAML.load(File.read(yml_file, aliases: true))
            env_config = yml_config.has_key?(Rails.env) ? yml_config[Rails.env] : yml_config
            const_name = File.basename(yml_file, ".yml").upcase
            CgConfig.const_set(const_name, self.recursive_symbolize_keys(env_config))
          end
        end
      end
      @app.call(env)
    end

    private
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
  end
end