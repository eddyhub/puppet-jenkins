# This class defines the next-executions plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::javadoc(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'javadoc':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
