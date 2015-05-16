# This class defines the script-security plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::script_security (
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'script-security':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
