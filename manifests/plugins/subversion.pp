# This class defines the subversion plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::subversion(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file_list = [
                       'hudson.scm.SubversionMailAddressResolverImpl.xml',
                       'hudson.scm.SubversionSCM.xml',
                       ]

  jenkins::plugin {'subversion':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
