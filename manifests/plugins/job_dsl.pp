# This class defines the ansicolor plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::job_dsl(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef
  jenkins::plugin {'job-dsl':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
