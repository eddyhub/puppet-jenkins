# This class defines the rake plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::rake(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'rake':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
