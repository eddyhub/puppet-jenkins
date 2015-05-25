#
class jenkins::proxy(
  $enable = true
  ) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $init_dir           = $jenkins::params::init_dir
  $proxy_config_order = $jenkins::params::proxy_config_order

  if $enable == true {
    # Bring variables from Class['::jenkins'] into local scope.
    $proxy_hostname     = $::jenkins::proxy_hostname
    $proxy_port         = $::jenkins::proxy_port
    $proxy_user_name    = $::jenkins::proxy_user_name
    $proxy_password     = $::jenkins::proxy_password
    $no_proxy_host_list = $::jenkins::no_proxy_host_list

    validate_string($proxy_hostname)
    # validate_interger is only available in stdlib => v4
    # validate_integer($proxy_port)
    validate_string($proxy_user_name)
    validate_string($proxy_password)
    if $no_proxy_host_list {
      validate_array($no_proxy_host_list)
    }

    file {"${init_dir}/${proxy_config_order}-proxy.groovy":
      ensure => present,
      content => template("jenkins/proxy.groovy.erb"),
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0600',
      notify  => Service['jenkins'],
    }
  }
  else {
    $proxy_xml = $jenkins::params::proxy_xml

    file {$proxy_xml:
      ensure => absent,
      notify  => Service['jenkins'],
    }

    file {"${init_dir}/${proxy_config_order}-proxy.groovy":
      ensure => absent,
      notify  => Service['jenkins'],
    }
  }
}
