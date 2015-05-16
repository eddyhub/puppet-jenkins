require 'fileutils'
require 'json'

Puppet::Type.type(:jenkins_plugin).provide(:jenkins_plugin) do
  desc 'Support for managing the jenkins plugins'

  commands :wget => 'wget'

  mk_resource_methods

  UPDATE_CENTER_JSON_HEADER = "updateCenter.post(\n {\"connectionCheckUrl\":\"http://www.google.com/\","
  UPDATE_CENTER_JSON_FOOTER = ",\"updateCenterVersion\":\"1\"}\n );"
  UPDATE_CENTER_URL = 'http://updates.jenkins-ci.org'
  UPDATE_CENTER_PLUGINS_URL = "#{UPDATE_CENTER_URL}/download/plugins"
  UPDATE_CENTER_JSON_URL = "#{UPDATE_CENTER_URL}/update-center.json"
  UPDATE_CENTER_JSON = 'update-center.json'

  def self.instances
    #puts("====================BEGIN: self.instances====================")
    plugins = []
    plugins_dir = Facter.value(:jenkins_plugins_dir)
    #If there is no plugins_dir than there is probably no jenkins installed -> no plugins
    if plugins_dir != ''
      # traverse the jenkins plugins dir and find all extracted plugins
      Dir.entries(plugins_dir).each do |plugin|
        next if (plugin == '..')
        next if (plugin == '.')
        plugin_path = File.join(plugins_dir, plugin)
        # FIXME: What about plugins which aren't extracted?
        next unless File.directory?(plugin_path) and (File.exist?("#{plugin_path}.hpi") or File.exist?("#{plugin_path}.jpi"))
        plugin_short_name = nil
        plugin_version = nil
        plugin_status = :enabled
        File.readlines(File.join(plugin_path, 'META-INF', 'MANIFEST.MF')).each do |line|
          line.chomp!
          tmp = line.split(": ")
          next unless tmp.length == 2
          key, value = tmp
          if key == 'Short-Name'
            plugin_short_name = value
          end
          if key == 'Plugin-Version'
            plugin_version = value
          end
        end
        if File.exist?("#{plugin_path}.hpi.disabled") or File.exist?("#{plugin_path}.jpi.disabled")
          plugin_status = :disabled
        end
        if plugin_short_name != nil and plugin_version != nil
          plugins << new(
            :name => plugin_short_name,
            :version => plugin_version,
            :ensure => :present,
            :status => plugin_status
          )
        end
        # plugin_short_name = nil
        # plugin_version = nil
        # plugin_status = :enabled
      end
      #puts("====================END: self.instances====================")
    end
    plugins
  end

  def self.prefetch(resources)
    #puts("====================BEGIN: self.prefetch====================")
    http_proxy = nil
    tmp_folder = nil
    plugins = instances
    jenkins_plugins_db = nil
    resources.keys.each do |name|
      if jenkins_plugins_db == nil
        http_proxy = resources[name][:http_proxy]
        https_proxy = resources[name][:https_proxy]
        tmp_folder = resources[name][:tmp_folder]
        begin
          jenkins_plugins_db = update_db(http_proxy, https_proxy, tmp_folder)
        rescue
          fail("Can't load #{UPDATE_CENTER_JSON_URL}")
        end
      end
      if provider = plugins.find {|plugin| plugin.name == name}
        resources[name].provider = provider
      end
      latest_version = Gem::Version.new(jenkins_plugins_db['plugins'][name]['version'])
      if resources[name][:version] == 'latest'
        resources[name][:version] = latest_version
      end
      begin
        resources[name][:latest_version] = latest_version
      rescue
        fail("Plugin #{resources[name]} does not exists!")
      end
    end
    #puts("====================END: self.prefetch====================")
  end

  # sets version
  def version=(value)
    #puts("====================BEGIN: self.version====================")
    create
    #puts("====================END: self.version====================")
  end

  # sets the status
  def status=(value)
    #puts("====================BEGIN: self.status====================")
    plugins_dir = File.join(resource[:plugins_dir], resource[:name])
    hpi = "#{plugins_dir}.hpi"
    jpi = "#{plugins_dir}.jpi"
    if File.exist?(hpi)
      xpi = "#{hpi}.disabled"
    else
      xpi = "#{jpi}.disabled"
    end
    if value == :enabled
      if File.exist?(xpi) then FileUtils.rm_rf(xpi) end
    else
      if !File.exist?(xpi) then FileUtils.touch(xpi) end
    end
    #puts("====================END: self.status====================")
  end

   def self.update_db(http_proxy, https_proxy, tmp_folder)
    #puts("====================BEGIN: update_db====================")
    params = []
    if http_proxy != "" and https_proxy == ''
      params << '-e'
      params << "http_proxy=#{http_proxy}"
      params << '--no-check-certificate'
    elsif https_proxy != ""
      params << '-e'
      params << "https_proxy=#{https_proxy}"
    end
    params << UPDATE_CENTER_JSON_URL
    params << '-N'
    params << '-P'
    params << tmp_folder
    wget(params)
    tmp_data = File.readlines(File.join(tmp_folder, UPDATE_CENTER_JSON)).join(" ")
    # remove PJSON elements
    tmp_data.gsub!(UPDATE_CENTER_JSON_HEADER, "{")
    tmp_data.gsub!(UPDATE_CENTER_JSON_FOOTER, "}")
    #puts("====================END: update_db====================")
    JSON.parse(tmp_data)
  end

  def install(http_proxy, https_proxy, plugin_host, plugin_name, version, plugins_dir)
    #puts("====================BEGIN: install====================")
    params = []
    if http_proxy != "" and https_proxy == ''
      params << '-e'
      params << "http_proxy=#{http_proxy}"
      params << '--no-check-certificate'
    elsif https_proxy != ""
      params << '-e'
      params << "https_proxy=#{https_proxy}"
    end
    hpi_url = "#{plugin_host}/download/plugins/#{plugin_name}/#{version}/#{plugin_name}.hpi"
    params << hpi_url
    params << '-N'
    params << '-P'
    params << plugins_dir
    delete(plugins_dir, plugin_name)
    hpi_file_path = File.join(plugins_dir, "#{plugin_name}.hpi")
    # try to download the plugin and fail if it doesn't exists than fail
    begin
      wget(params)
    rescue Puppet::ExecutionFailure
      fail("Version #{resource[:version]} of plugin #{resource[:name]} is not available\nURL: #{hpi_url}")
    end
    begin
      FileUtils.chown_R(resource[:owner], resource[:group], hpi_file_path)
      FileUtils.touch("#{hpi_file_path}.pinned")
    rescue
      fail("Could not set permissions for the file #{hpi_file_path} to user: #{resource[:owner]} and group: #{resource[:group]}")
    end
    #puts("====================END: install====================")
  end

  def delete(plugins_dir, plugin_name)
    #puts("====================BEGIN: delete====================")
    if File.exist?(File.join(plugins_dir, plugin_name))
      dir = File.join(plugins_dir, plugin_name)
      hpi = File.join(plugins_dir, "#{plugin_name}.hpi")
      jpi = File.join(plugins_dir, "#{plugin_name}.jpi")
      hpi_disabled = File.join(plugins_dir, "#{plugin_name}.hpi.disabled")
      jpi_disabled = File.join(plugins_dir, "#{plugin_name}.jpi.disabled")
      hpi_pinned = "#{hpi}.pinned"
      jpi_pinned = "#{jpi}.pinned"
      if File.exist?(dir) then FileUtils.rm_rf(dir) end
      if File.exist?(hpi) then FileUtils.rm_rf(hpi) end
      if File.exist?(jpi) then FileUtils.rm_rf(jpi) end
      if File.exist?(hpi_disabled) then FileUtils.rm_rf(hpi_disabled) end
      if File.exist?(jpi_disabled) then FileUtils.rm_rf(jpi_disabled) end
      if File.exist?(hpi_pinned) then FileUtils.rm_rf(hpi_pinned) end
      if File.exist?(jpi_pinned) then FileUtils.rm_rf(jpi_pinned) end
    end
    #puts("====================END: delete====================")
  end

  def create
    #puts("====================BEGIN: create====================")
    # puts("RESOURCE: #{resource[:name]}")
    # puts("latest_version: #{resource[:latest_version]}")
    # puts("required_version: #{resource[:version]}")
    # puts("installed_version: #{@property_hash[:version]}")
    # get the version number of the latest plugin version
    latest_version = Gem::Version.new(resource[:latest_version])
    required_version = Gem::Version.new(resource[:version])
    begin
      installed_version = Gem::Version.new(@property_hash[:version])
    rescue
      installed_version = nil
    end
    # check if we already have installed the required version
    if installed_version == nil || installed_version != required_version
      install(resource[:http_proxy], resource[:https_proxy], resource[:plugin_host], resource[:name], required_version, resource[:plugins_dir])
    end
    @property_hash[:version] = required_version
    @property_hash[:ensure] = :present
    @property_hash[:status] = :enabled
    #puts("====================END: create====================")
   end

  def destroy
    #puts("====================BEGIN: destroy====================")
     delete(resource[:plugins_dir], resource[:name])
    @property_hash[:ensure] = :absent
    #puts("====================END: destroy====================")
  end

  def exists?
    #puts("====================BEGIN: exists?====================")
    #puts("====================END: exists====================")
    @property_hash[:ensure] == :present
  end

  # def flush
  #   #puts("====================BEGIN: flush====================")
  #   puts(resource)
  #   #puts("====================END: flush====================")
  # end
end
