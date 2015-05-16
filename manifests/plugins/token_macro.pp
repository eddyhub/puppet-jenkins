# This class defines the token-macro plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::token_macro(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'token-macro':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
