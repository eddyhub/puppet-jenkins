# This class defines the matrix-auth plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::matrix_auth(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'matrix-auth':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
