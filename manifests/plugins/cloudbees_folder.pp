# This class defines the cloudbees-folder plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::cloudbees_folder(
  $version = latest,
  $ensure  = present,
  $url     = undef,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'cloudbees-folder':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
