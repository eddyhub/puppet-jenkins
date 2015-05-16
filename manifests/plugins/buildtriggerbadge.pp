# This class defines the buildtriggerbadge plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::buildtriggerbadge(
  $version = latest,
  $ensure  = present,
  $url     = undef,
  $status  = enabled,
  ) {

  $config_file = 'buildtriggerbadge.xml'

  jenkins::plugin {'buildtriggerbadge':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
