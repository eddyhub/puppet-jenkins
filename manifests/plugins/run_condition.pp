# This class defines the run-condition plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::run_condition(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'run-condition':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
