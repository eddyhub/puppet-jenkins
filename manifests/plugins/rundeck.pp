# This class defines the rundeck plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::rundeck(
  $rundeck_url         = undef,
  $api_version = 9,
  $login       = undef,
  $password    = undef,
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $init_dir = $jenkins::params::init_dir
  $plugin_config_configs_order = $jenkins::params::plugin_config_configs_order

  $config_file = 'org.jenkinsci.plugins.rundeck.RundeckNotifier.xml'

  jenkins::plugin {'rundeck':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
  file {"${init_dir}/${plugin_config_configs_order}-plugin__rundeck__config.groovy":
    ensure => present,
    content => template("jenkins/rundeck_plugin_config.groovy.erb"),
    owner   => $jenkins::params::username,
    group   => $jenkins::params::group,
    mode    => '0600',
    notify  => Service['jenkins'],
  }

  # file {"${jenkins::params::home_dir}/${config_file}":
  #   ensure => present,
  #   source => "puppet:///modules/${module_name}/${config_file}",
  #   owner   => $jenkins::params::username,
  #   group   => $jenkins::params::group,
  #   mode    => '0644',
  #   replace => false,
  #   notify  => Service['jenkins']
  # }

  # if $url != undef or $login != undef or $password != undef {
  #   validate_string($url)
  #   validate_string($login)
  #   validate_string($password)

  #   jenkins_augeas {"${jenkins::params::home_dir}/${config_file} -- configuring rundeck plugin":
  #     incl => "${jenkins::params::home_dir}/${config_file}",
  #     context => "/files/${jenkins::params::home_dir}/${config_file}/org.jenkinsci.plugins.rundeck.RundeckNotifier_-RundeckDescriptor/rundeckInstance/",
  #     changes => [
  #                 "set url/#text \"${url}\"",
  #                 "set apiVersion/#text \"${api_version}\"",
  #                 "set login/#text \"${login}\"",
  #                 #ATTENTION: the rundeck plugin doesn't use the encryption api of jenkins, so the password has to be clear text
  #                 "set password/#text \"${password}\"",
  #                 ],
  #     require => File["${jenkins::params::home_dir}/${config_file}"],
  #     notify => Service['jenkins'],
  #   }
  # }
}
