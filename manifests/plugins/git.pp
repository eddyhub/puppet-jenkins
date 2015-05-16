# This class defines the git plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::git(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'git':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
