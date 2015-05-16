# This class defines the ansicolor plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::ansicolor(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'hudson.plugins.ansicolor.AnsiColorBuildWrapper.xml'

  jenkins::plugin {'ansicolor':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
