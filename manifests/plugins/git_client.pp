# This class defines the git plugin
#
# parameter: see plugin.pp for a detailed description
#
# We use jgit as default because it works seamlessly with jenkins and
# it's credentials storge https://issues.jenkins-ci.org/browse/JENKINS-20879
#

class jenkins::plugins::git_client(
  $git_tool = 'jgit',
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'hudson.plugins.git.GitTool.xml'
  $init_dir = $jenkins::params::init_dir
  $plugin_config_configs_order = $jenkins::params::plugin_config_configs_order

  validate_string($git_tool)
  if $git_tool == "" { fail("Please supply a valid path to the git executable") }

  jenkins::plugin {'git-client':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
  file {"${init_dir}/${plugin_config_configs_order}-plugin__git-client__config.groovy":
    ensure  => $ensure,
    content => template("jenkins/git_client_plugin_config.groovy.erb"),
    owner   => $jenkins::params::username,
    group   => $jenkins::params::group,
    mode    => '0600',
    notify  => Service['jenkins'],
  }
}
