# This class defines the any-buildstep plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::any_buildstep(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = ''

  jenkins::plugin {'any-buildstep':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
