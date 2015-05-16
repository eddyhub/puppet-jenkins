# Parameters:
# config_hash = {} (Default)
# Hash with config options to set in sysconfig/jenkins defaults/jenkins
#
# Example use
#
# class{ 'jenkins::config':
#   config_hash => {
#     'HTTP_PORT' => { 'value' => '9090' }, 'AJP_PORT' => { 'value' => '9009' }
#   }
# }
#
class jenkins::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  include jenkins::package

  Class['Jenkins::Package']->Class['Jenkins::Config']
  create_resources( 'jenkins::sysconfig', $::jenkins::config_hash )

  if (!defined(File[$jenkins::params::init_dir])) {
    file {$jenkins::params::init_dir:
      ensure  => directory,
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0700',
      require => [Group[$jenkins::params::group], User[$jenkins::params::username]],
    }
  }

  if (!defined(Group[$jenkins::params::group])) {
    group { $jenkins::params::group :
      ensure  => present,
      require => Package['jenkins'],
    }
  }

  if (!defined(User[$jenkins::params::username])) {
    user { $jenkins::params::username :
      ensure  => present,
      home    => $jenkins::params::home_dir,
      require => Package['jenkins'],
    }
  }
}

