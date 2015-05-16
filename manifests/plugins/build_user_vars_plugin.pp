# This class defines the build-user-vars-plugin plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::build_user_vars_plugin(
  $version = latest,
  $ensure  = present,
  $url     = undef,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'build-user-vars-plugin':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
