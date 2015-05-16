# This class defines the  envinject plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::envinject(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'envInject.xml'

  jenkins::plugin {'envinject':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
