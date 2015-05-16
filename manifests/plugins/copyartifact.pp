# This class defines the copyartifact plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::copyartifact(
  $version = latest,
  $ensure  = present,
  $url     = undef,
  $status  = enabled,
  ) {

  $config_file = 'hudson.plugins.copyartifact.TriggeredBuildSelector.xml'

  jenkins::plugin {'copyartifact':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
