# This class defines the mailer plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::mailer(
  $default_suffix   = undef,
  $hudson_url       = undef,
  #$admin_address    = 'adress not configured yet',
  $use_ssl          = true,
  $charset          = 'UTF-8',
  $reply_to_address = 'adress not configured yet',
  $smtp_host        = undef,
  $smtp_port        = 25,
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {


  $init_dir = $jenkins::params::init_dir
  $plugin_config_configs_order = $jenkins::params::plugin_config_configs_order

  $config_file = 'hudson.tasks.Mailer.xml'

  jenkins::plugin {'mailer':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
  file {"${init_dir}/${plugin_config_configs_order}-plugin__mailer__config.groovy":
    ensure => present,
    content => template("jenkins/mailer_plugin_config.groovy.erb"),
    owner   => $jenkins::params::username,
    group   => $jenkins::params::group,
    mode    => '0600',
    notify  => Service['jenkins'],
  }


  # if $default_suffix != undef and $hudson_url != undef and $smtp_host != undef{
  #   validate_string($default_suffix)
  #   validate_string($hudson_url)
  #   validate_string($admin_address)
  #   validate_bool($use_ssl)
  #   validate_string($charset)
  #   validate_string($smtp_host)
  #   validate_string($smtp_port)
  #   #validate_integer($smtp_port)
  #   validate_string($reply_to_address)

  #   jenkins_augeas {"${jenkins::params::home_dir}/${config_file} -- configuring mailer plugin":
  #     incl => "${jenkins::params::home_dir}/${config_file}",
  #     context => "/files/${jenkins::params::home_dir}/${config_file}/hudson.tasks.Mailer_-DescriptorImpl/",
  #     changes => [
  #                 "set defaultSuffix/#text \"${default_suffix}\"",
  #                 "set hudsonUrl/#text \"${hudson_url}\"",
  #                 "set adminAddress/#text \"${admin_address}\"",
  #                 "set replyToAddress/#text \"${reply_to_address}\"",
  #                 "set smtpHost/#text \"${smtp_host}\"",
  #                 "set useSsl/#text \"${use_ssl}\"",
  #                 "set smtpPort/#text \"${smtp_port}\"",
  #                 "set charset/#text \"${charset}\"",
  #                 ],
  #     notify => Service['jenkins'],
  #     require => File["${jenkins::params::home_dir}/${config_file}"],

  #   }
  # }
}
