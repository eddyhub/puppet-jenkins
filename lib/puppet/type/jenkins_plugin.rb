Puppet::Type.newtype(:jenkins_plugin) do
@doc = "Manages the plugins of jenkins.

A typical plugin added via this type:
jenkins_plugin {'credentials'
  ensure => present,
  status => enabled,
  version => latest,
  plugin_host => 'http://updates.jenkins-ci.org',
  http_proxy => 'http://myproxy.fobar'
  https_proxy => 'https://myproxy.foobar'
  jenkins_plugins_dir => '/var/lib/jenkins/plugins'
}
"

  desc 'The jenkins_plugin type'

  ensurable

  newparam(:name) do
    isnamevar
    desc 'The name of the plugin to download.'
  end

  newparam(:plugins_dir) do
    desc 'The path to the directory jenkins uses for its plugins'
  end

  newparam(:owner) do
    desc 'The path to the directory jenkins uses for its plugins'
    defaultto 'jenkins'
  end

  newparam(:group) do
    desc 'The path to the directory jenkins uses for its plugins'
    defaultto 'jenkins'
  end

  newparam(:http_proxy) do
    desc 'URL to a proxy we should use to download the plugin'
    defaultto ''
  end

  newparam(:https_proxy) do
    desc 'URL to a proxy we should use to download the plugin'
    defaultto ''
  end

  newparam(:tmp_folder) do
    desc 'Folder where it is possible to cache the update-center.json db'
    defaultto '/tmp'
  end

  newparam(:latest_version) do
    desc 'This varaible will be set in self.prefetch so do not use it'
    defaultto ''
  end

  newparam(:installed_version) do
    desc 'This varaible will be set in self.prefetch so do not use it'
    defaultto ''
  end

  newparam(:url_latest_version) do
    desc 'This varaible will be set in self.prefetch so do not use it'
    defaultto ''
  end

  #TODO: implement https links
  newparam(:plugin_host) do
    desc 'URL to the host which provides the plugins (updates.jenkins-ci.org)'
    defaultto 'http://updates.jenkins-ci.org'
  end

  newproperty(:version) do
    desc 'The version of the installed plugin.'
    defaultto 'latest'
  end

  newproperty(:status) do
    desc 'The status of the plugin.'
    defaultto :enabled
    newvalues(:enabled, :disabled)
  end

end
