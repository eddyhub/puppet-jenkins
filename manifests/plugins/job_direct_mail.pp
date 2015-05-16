# This class defines the job-direct-mail plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::job_direct_mail(
  $version     = latest,
  $ensure      = present,
  $plugin_host = $jenkins::params::plugin_host,
  $status      = enabled,
  ) {

  $config_file  = 'org.jenkinsci.plugins.jobmail.configuration.JobMailGlobalConfiguration.xml'

  jenkins::plugin {'job-direct-mail':
    version     => $version,
    plugin_host => $plugin_host,
    ensure      => $ensure,
    status      => $status,
  }->
  file {"${jenkins::params::home_dir}/${config_file}":
    ensure => present,
    source => "puppet:///modules/${module_name}/${config_file}",
    owner   => $jenkins::params::username,
    group   => $jenkins::params::group,
    mode    => '0644',
    replace => false,
    notify  => Service['jenkins']
  }
}
