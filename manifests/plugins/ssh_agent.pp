# This class defines the ssh-agent plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::ssh_agent(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = ''

  jenkins::plugin {'ssh-agent':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
