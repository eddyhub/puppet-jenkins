# This class defines the flexible-push plugin
#
# parameter: see plugin.pp for a detailed description

class jenkins::plugins::flexible_publish(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'org.jenkins_ci.plugins.flexible_publish.FlexiblePublisher.xml'

  jenkins::plugin {'flexible-publish':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
