# This class defines the ansicolor plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::publish_over_ssh(
  $encrypted_passphrase = undef,
  $key = undef,
  $disable_all_exec = true,
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  validate_string($encrypted_passphrase)
  validate_string($key)
  validate_bool($disable_all_exec)

  $init_dir = $jenkins::params::init_dir
  $plugin_config_configs_order = $jenkins::params::plugin_config_configs_order

  $config_file = 'jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml'

  jenkins::plugin {'publish-over-ssh':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }

  file {"${init_dir}/${plugin_config_configs_order}-plugin__publish-over-ssh__config.groovy":
    ensure => present,
    content => template("jenkins/publish_over_ssh_plugin_config.groovy.erb"),
    owner   => $jenkins::params::username,
    group   => $jenkins::params::group,
    mode    => '0600',
    notify  => Service['jenkins'],
  }

}
