define jenkins::job(
  $job_xml = undef,
  $enable = true
  ) {

  $jobs_dir           = $jenkins::params::jobs_dir

  if $job_xml == undef {
    fail("You have to specify the job_xml to create the job ${title}")
  }
  if $enable == true {
    file {"${jobs_dir}/${title}":
      ensure => directory,
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0755',
      notify  => Service['jenkins'],
    }

    file {"${jobs_dir}/${title}/config.xml":
      ensure => present,
      content => $job_xml,
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0644',
      notify  => Service['jenkins'],
    }
  }
  else {
    file {"${jobs_dir}/${title}":
      ensure => absent,
      recurse => true,
      force => true,
      notify  => Service['jenkins'],
    }
  }
}
