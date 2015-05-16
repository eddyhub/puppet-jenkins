# This class defines the filesystem-scm plugin
#
# parameter: see plugin.pp for a detailed description

class jenkins::plugins::filesystem_scm(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'filesystem_scm':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
