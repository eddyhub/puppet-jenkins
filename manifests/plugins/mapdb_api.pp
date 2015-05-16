# This class defines the mapdb-api plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::mapdb_api(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'mapdb-api':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
