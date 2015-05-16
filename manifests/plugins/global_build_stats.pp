# This class defines the global-build-stats plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::global_build_stats(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'global-build-stats.xml'

  jenkins::plugin {'global-build-stats':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
