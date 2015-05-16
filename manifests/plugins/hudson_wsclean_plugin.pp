# This class defines the hudson-wsclean-plugin plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::hudson_wsclean_plugin(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'hudson-wsclean-plugin':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
