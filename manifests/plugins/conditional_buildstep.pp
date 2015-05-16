# This class defines the conditional-buildstep plugin
#
# parameter: see plugin.pp for a detailed description
class jenkins::plugins::conditional_buildstep(
  $version = latest,
  $ensure  = present,
  $url     = undef,
  $status  = enabled,
  ) {

  $config_file = 'org.jenkinsci.plugins.conditionalbuildstep.singlestep.SingleConditionalBuilder.xml'

  jenkins::plugin {'conditional-buildstep':
    version => $version,
    url     => $url,
    ensure  => $ensure,
    status  => $status,
  }
}
