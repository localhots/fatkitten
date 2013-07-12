class Configuration
  attr_reader :database_url,
              :syntaxes_map,
              :available_syntaxes

  def initialize
    load_database_config
    load_syntax_config
  end

  private

  def load_database_config
    config = YAML.load_file(APP_ROOT.join('config', 'database.yml'))
    @database_url = '%s://%s:%s@%s:%s/%s' % [
      config['protocol'],
      config['username'],
      config['password'],
      config['host'],
      config['port'],
      config['database']
    ]
  end

  def load_syntax_config
    config = YAML.load_file(APP_ROOT.join('config', 'syntax.yml'))
    @syntaxes_map = config
    @available_syntaxes = config.keys
  end
end
