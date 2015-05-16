# This class defines the vsphere-cloud plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::vsphere_cloud(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = undef

  jenkins::plugin {'vsphere-cloud':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
