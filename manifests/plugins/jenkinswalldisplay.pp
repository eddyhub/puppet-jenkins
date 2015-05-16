# This class defines the jenkinswalldisplay plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::jenkinswalldisplay(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'de.pellepelster.jenkins.walldisplay.WallDisplayPlugin.xml'

  jenkins::plugin {'jenkinswalldisplay':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
