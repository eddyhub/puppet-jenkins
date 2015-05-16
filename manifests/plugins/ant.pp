# This class defines the ant plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::ant(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'hudson.tasks.Ant.xml'

  jenkins::plugin {'ant':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
