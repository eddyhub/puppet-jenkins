# This class defines the credentials plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::credentials(
  $version = latest,
  $ensure  = present,
  $url     = undef,
  $status  = enabled,
  ) {

  $config_file = 'credentials.xml'

  jenkins::plugin {'credentials':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
