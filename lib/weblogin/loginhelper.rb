require 'highline/import'
require 'parseconfig'
require 'zlog'

# Login helper, get credentials
module LoginHelper
  Log = Logging.logger[self]

  def config_file
    @config_file ||= "~/.weblogin.conf"
  end

  def provider_user provider = nil
    return nil if provider.nil?
    @users[provider] ||= get_open("Enter username for #{provider}: ", "user", provider)
  end

  def provider_password provider = nil
    return nil if provider.nil?
    @passwords[provider] ||= get_secret("Enter password for #{provider} (will not be shown): ", "password", provider)
  end

  def get_or_set field, group, &block
    # get the field from file...
    f = get_from_config_file field, group
    # ... or ask the user to provide it and save it then
    if f.nil?
      f = block.()
      save_to_config_file field, f, group
    end
    f
  end

  private

  def get_conf
    conf_path = File::expand_path(config_file)
    if not File::exists?(conf_path)
      Log.info "Creating configuration in #{conf_path}"
      File::write(conf_path,"")
    elsif not File::file?(conf_path)
      Log.abort "Can't write configuration file to #{conf_path}"
    end
    ParseConfig.new(conf_path)
  end

  def get_from_config_file field, group = nil
    config = get_conf
    return config.params[field] if (group.nil?)
    (config.params[group].nil?) ? nil : config.params[group][field]
  end

  def save_to_config_file field, value, group = nil
    config = get_conf
    # add the field/value/group
    if group.nil?
      config.add field, value
    else
      config.add_to_group group, field, value.to_s
    end
    # get the path
    path = File::expand_path(config_file)
    # write the contents to the file
    file = File.open(path, 'w+')
    config.write(file)
    file.close
    # limit permissions to this file
    File.chmod(0600, path)
  end

  def get_open prompt, field
    get_or_set field do
      cli.ask(prompt){|q| q.echo = true}.strip
    end
  end

  def get_secret prompt, field
    get_or_set field do
      cli.ask(prompt){|q| q.echo = '*'}.strip
    end
  end

  def cli; @cli ||= HighLine.new; end

end
