# This class defines the next-executions plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::junit(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'junit':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
