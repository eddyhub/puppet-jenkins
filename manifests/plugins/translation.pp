# This class defines the translation plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::translation (
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'translation':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
