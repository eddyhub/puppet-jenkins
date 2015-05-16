# This class defines the antisamy-markup-formatter plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::antisamy_markup_formatter (
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'antisamy-markup-formatter':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
