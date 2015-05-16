# This class defines the maven-plugin plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::maven_plugin(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'hudson.maven.MavenModuleSet.xml'

  jenkins::plugin {'maven-plugin':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
