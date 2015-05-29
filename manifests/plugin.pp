# Resource: jenkins::plugins
# This resource describes a simple plugin. It downloads the necessary
# plugin in the requested version and copies it to the correct directory.
#
# version: version which should be installed. If version is 0, than the
# most recent version will be installed.
#
# config_hash: contains the filename and variables which should be
# replaced in the template (template = filename.erb) to configure the
# plugin.
#
# If update_url => "http://www.google.de" than the plugin must be located in
# https://www.google.de/download/plugins/(plugin-name)/[(version)|(latest)]/(plugin-name).
#
define jenkins::plugin(
  $short_name  = $name,
  $version     = 'latest',
  $url         = undef,
  $ensure      = present,
  $status      = enabled,
  ) {

  if !defined(Class['jenkins']) {
    fail("${jenkins::params::exception_header}Exception occurred trying to install plugin: ${title}\nException message: You must include the jenkins base class before using any jenkins defined resources!${jenkins::params::exception_footer}")
  }
  validate_re($ensure, ['^present$', '^absent$'])
  validate_re($status, ['^enabled$', '^disabled$'])

  if $version != 'latest' and url == undef {
    fail("${jenkins::params::exception_header}Exception occurred trying to install plugin: ${title}\nException message: You have to specify an URL if you want to install a specific version${jenkins::params::exception_footer}")
  }

  $init_dir = $jenkins::params::init_dir
  $plugin_config_order = $jenkins::params::plugin_config_order
  $plugins_dir =  $jenkins::params::plugins_dir
  $json_dir = "${init_dir}/plugins"

  if (!defined(File["${init_dir}/${plugin_config_order}-plugin.groovy"])) {
    file {"${init_dir}/${plugin_config_order}-plugin.groovy":
      ensure => present,
      content => template("jenkins/plugin.groovy.erb"),
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0600',
      notify  => Service['jenkins'],
    }
  }
  if (!defined(File[$json_dir])) {
    file {$json_dir:
      ensure => directory,
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0700',
      notify  => Service['jenkins'],
    }
  }


  #Class['Jenkins::Config']->Jenkins::Plugin["${title}"]
  if $ensure == 'present' {
    file {"${json_dir}/plugin__${name}__.json":
      ensure => present,
      content => template("jenkins/plugin.json.erb"),
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0600',
      require => File[$json_dir],
      notify  => Service['jenkins'],
    }

    # There is the possibility someone removed the plugins from the
    # filesystem, if so only a restart (notify service) is required
    # because the template in init.groovy.d has not changed
    exec {"plugin: ${name} not installed -> restart":
      command         => "echo plugin: ${name} not installed -> restart jenkins",
      onlyif          => "test ! -f ${plugins_dir}/${name}.hpi -a ! -f ${plugins_dir}/${name}.jpi",
      path            => ['/usr/bin','/usr/sbin','/bin','/sbin'],
      notify  => Service['jenkins'],
    }
  }
  else {
    file {"${init_dir}/${plugin_config_order}-plugin__${name}__.groovy":
      ensure => absent,
      notify  => Service['jenkins'],
    }
    file {"${plugins_dir}/${name}.hpi":
      ensure => absent,
      notify  => Service['jenkins'],
    }
    file {"${plugins_dir}/${name}.jpi":
      ensure => absent,
      notify  => Service['jenkins'],
    }
    file {"${plugins_dir}/${name}":
      ensure => absent,
      force => true,
      notify  => Service['jenkins'],
    }
  }
}

