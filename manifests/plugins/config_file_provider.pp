# This class defines the config-file-provider plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::config_file_provider(
  $version = latest,
  $ensure  = present,
  $url     = undef,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'config-file-provider':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
