# This class defines the scm plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::scm_api(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'scm-api':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
