# This class defines the ssh-credentials plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::ssh_credentials(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'ssh-credentials':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
