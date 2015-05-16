# This class defines the svn-tag plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::svn_tag(
  $default_tag_base_url = undef,
  $tag_comment          = undef,
  $tag_delete_comment   = undef,
  $version              = latest,
  $ensure               = present,
  $plugin_host          = $jenkins::params::plugin_host,
  $status               = enabled,

  ) {

  $config_file     = 'hudson.plugins.svn_tag.SvnTagPublisher.xml'

  jenkins::plugin {'svn-tag':
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

  if $default_tag_base_url != undef or $tag_comment != undef or $tag_delete_comment != undef {
    validate_string($default_tag_base_url)
    validate_string($tag_comment)
    validate_string($tag_delete_comment)

    jenkins_augeas {"${jenkins::params::home_dir}/${config_file} -- configuring svn_tag plugin":
      incl => "${jenkins::params::home_dir}/${config_file}",
      context => "/files/${jenkins::params::home_dir}/${config_file}/hudson.plugins.svn__tag.SvnTagPublisher_-SvnTagDescriptorImpl/",
      changes => [
                  "set defaultTagBaseURL/#text \"${default_tag_base_url}\"",
                  "set tagComment/#text \"${tag_comment}\"",
                  "set tagDeleteComment/#text \"${tag_delete_comment}\"",
                  ],
      require => File["${jenkins::params::home_dir}/${config_file}"],
      notify => Service['jenkins'],
    }
  }
}
