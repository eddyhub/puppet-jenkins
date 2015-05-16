# This class defines the email-ext plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::email_ext(
  $version = latest,
  $url     = undef,
  $ensure  = present,
  $status  = enabled,
  ) {

  $config_file = 'hudson.plugins.emailext.ExtendedEmailPublisher.xml'

  jenkins::plugin {'email-ext':
    url     => $url,
    version => $version,
    ensure  => $ensure,
    status  => $status,
  }
}
