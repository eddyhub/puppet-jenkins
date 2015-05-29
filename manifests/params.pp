# Class: jenkins::params
#
#
class jenkins::params {
  $version             = 'installed'
  $lts                 = false
  $repo                = true
  $service_enable      = true
  $service_ensure      = 'running'
  $install_java        = true
  $swarm_version       = '1.19'
  $plugin_host         = 'http://updates.jenkins-ci.org'
  $port                = '8080'
  $cli_tries             = 10
  $cli_try_sleep         = 10
  $package_cache_dir     = '/var/cache/jenkins_pkgs'
  $package_name          = 'jenkins'

  $home_dir            = "/var/lib/jenkins"
  $init_dir            = "${home_dir}/init.groovy.d"
  $config_xml          = "${home_dir}/config.xml"
  $proxy_xml           = "${home_dir}/proxy.xml"
  $credentials_xml     = "${home_dir}/credentials.xml"
  $jobs_dir            = "${home_dir}/jobs"
  $plugins_dir         = "${home_dir}/plugins"
  $nodes_dir           = "${home_dir}/nodes"
  $users_dir           = "${home_dir}/users"
  $username            = 'jenkins'
  $group               = 'jenkins'
  $secrets_dir         = "${home_dir}/secrets"
  $master_key          = "${secrets_dir}/master.key"
  $hudson_util_secret  = "${secrets_dir}/hudson.util.Secret"
  $exception_header    = "\n===================================Exception====================================\n"
  $exception_footer    = "\n================================================================================\n"


  $proxy_config_order  = 100
  $plugin_config_order = 1000
  $plugin_config_configs_order = 1001
  $security_config_order = 2000
  $user_config_order = 3000
  $credentials_domain_config_order = 4000
  $credentials_config_order = 5000
  $node_config_order = 6000
  $job_config_order = 7000


  case $::osfamily {
    'Debian': {
      $libdir           = '/usr/share/jenkins'
      $package_provider = 'dpkg'
    }
    'RedHat': {
      $libdir           = '/usr/lib/jenkins'
      $package_provider = 'rpm'
    }
    default: {
      $libdir = '/usr/lib/jenkins'
      $package_provider = false
    }
  }
}
