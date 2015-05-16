# This class defines the next-executions plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::next_executions(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'hudson.plugins.nextexecutions.NextBuilds.xml'

  jenkins::plugin {'next-executions':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
