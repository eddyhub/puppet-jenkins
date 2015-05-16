# This class defines the groovy plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::groovy(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'hudson.plugins.groovy.Groovy.xml'

  jenkins::plugin {'groovy':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
