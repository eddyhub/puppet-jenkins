# Class jenkins::init_job
# This is the initial job which creates other jobs using the job-dsl
# plugin: https://wiki.jenkins-ci.org/display/JENKINS/Job+DSL+Plugin


  # if ! defined(Class['jenkins']) or ! defined(Class['jenkins::plugins::job_dsl']) {
  #   fail('You must include the jenkins base and the job_dsl plugin classes before using init_job!')
  # }

class jenkins::init_job(
  $machine_list = [],
  $user = "toor",
  $machine_command = "",
  $puppet_module_list = [],
  $svnpro_ep3_credentials_id = "",
  ){

  validate_string($user)
  validate_array($machine_list)
  validate_array($puppet_module_list)

  $init_job_path = "${jenkins::params::jobs_dir}/init_job"
  $workspace_path = "${init_job_path}/workspace"
  $puppet_fs_scm_path = "${init_job_path}/puppet_fs_scm"
  $config_xml_path = "${init_job_path}/config.xml"
  $init_job_groovy = "${puppet_fs_scm_path}/init_job.groovy"

  file{$init_job_path:
    ensure => directory,
    owner => $::jenkins::params::username,
    group => $::jenkins::params::group,
  }

  file{$puppet_fs_scm_path:
    ensure => directory,
    owner => $::jenkins::params::username,
    group => $::jenkins::params::group,
  }

  file{$workspace_path:
    ensure => directory,
    owner => $::jenkins::params::username,
    group => $::jenkins::params::group,
  }

  file{$config_xml_path:
    ensure => present,
    content => template('jenkins/init_job.xml.erb'),
    owner => $::jenkins::params::username,
    group => $::jenkins::params::group,
    notify => Service['jenkins'],
  }

  file{$init_job_groovy:
    ensure => present,
    content => template('jenkins/init_job.groovy.erb'),
    owner => $::jenkins::params::username,
    group => $::jenkins::params::group,
  }

  # Class['jenkins::init_job']~>Class['jenkins::service']
}
