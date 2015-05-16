# This class defines the ldap plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::build_flow_plugin(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'build-flow-plugin':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
