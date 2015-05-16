# This class defines the pam-auth plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::pam_auth (
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'pam-auth':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
