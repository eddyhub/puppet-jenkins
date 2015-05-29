#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Type jenkins::slaves::ssh
#
# A jenkins slave
# TODO
# -implement more options for retention_strategy
# -slaves should be purged automaticaly if they aren't defined
# -write more documentation
#
##############
# Parameters #
##############
#
# description = 'Managed by puppet!' (Default)
#   Optional human-readable description of this slave.
#
#
# remote_fs = undef
#   A slave needs to have a directory dedicated to Jenkins. Specify the path of this work directory on the slave.
#
# num_executors = 1 (default)
#   This controls the number of concurrent builds that Jenkins can perform.

# mode = 'NORMAL' (default)
#   This controls the number of concurrent builds that Jenkins can perform.
#   Possible values are
#     NORMAL = Utilize this node as much as possible
#     EXCLUSIVE = Only build jobs with label restrictions matching this node
#
# retention_strategy = 'hudson.slaves.RetentionStrategy$Always' (default)
#   Controls when Jenkins starts and stops the slave.
#   Possible values are
#     hudson.slaves.RetentionStrategy$Always = Keep this slave on-line
#   as much as possible
#     hudson.slaves.RetentionStrategy$Demand = IMPLEMETED AND DOCUMENT ME
#     hudson.slaves.SimpleScheduledRetentionStrategy = IMPLEMETED AND DOCUMENT ME
#
# launcher = 'hudson.plugins.sshslaves.SSHLauncher' (default)
#   Controls how Jenkins starts this slave.
#   Possible values are
#     hudson.plugins.sshslaves.SSHLauncher = Launch slave agents on
#   Unix machines via SSH
#
# host = undef (default)
#   ONLY AVAILABLE for launcher = 'hudson.plugins.sshslaves.SSHLauncher)
#   Hostname of the slave
#
# port = 22 (default)
#   ONLY AVAILABLE for launcher = 'hudson.plugins.sshslaves.SSHLauncher)
#   Port of the host
#
# credentials_id = undef (default)
#   ONLY AVAILABLE for launcher = 'hudson.plugins.sshslaves.SSHLauncher)
#   Select the credentials id to be used for logging in to the remote host.
#
# max_num_retries = 0 (default)
#   ONLY AVAILABLE for launcher = 'hudson.plugins.sshslaves.SSHLauncher)
#   Set the number of times the SSH connection will be retried if the
#   initial connection results in an error. If empty, retrying will be
#   disabled.
#
# retry_wait_time = 0 (default)
#   ONLY AVAILABLE for launcher = 'hudson.plugins.sshslaves.SSHLauncher)
#   Set the number of seconds to wait between retry attempts of the
#   initial SSH connection. Only used if "Maximum Number of Retries"
#   is enabled.
#
# label = $title (default)
#   Labels (AKA tags) are used for grouping multiple slaves into one
#   logical group. Use spaces between each label. For instance
#   'regression java6' will assign a node the labels 'regression' and
#   'java6'.
#
# user_id = undef (default)
#   user which created this slave
#
# ensure = 'present' (default)
#   Whether the slave should exist.
#   Possible values are 'present', 'absent'

define jenkins::node (
  $node_description   = 'Managed by puppet!',
  $remote_fs          = undef,
  $num_executors      = 1,
  $mode               = 'Node.Mode.NORMAL',
  $retention_strategy = 'always',
  $host               = undef,
  $port               = 22,
  $credentials_id     = undef,
  $launcher_timeout_seconds = 0,
  $max_num_retries    = 0,
  $retry_wait_time    = 0,
  $label              = $title,
  $ensure             = 'present',
  ){

  validate_string($name)
  validate_string($description)
  validate_string($remote_fs)
  #validate_integer($num_executors)
  validate_string($mode)
  validate_string($retention_strategy)
  validate_string($launcher)
  validate_string($host)
  #validate_integer($port)
  validate_string($credentials_id)
  #validate_integer($max_num_retries)
  #validate_integer($retry_wait_time)
  validate_string($label)
  validate_string($ensure)
  validate_re($ensure, ['^present$', '^absent$'])

  Class['Jenkins::Config']->Jenkins::Node["${title}"]

  $init_dir          = $jenkins::params::init_dir
  $nodes_dir         = $jenkins::params::nodes_dir
  $node_config_order = $jenkins::params::node_config_order

  if $ensure == 'present' {
    file {"${init_dir}/${node_config_order}-node__${title}__.groovy":
      ensure => present,
      content => template("jenkins/node.groovy.erb"),
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0600',
      notify  => Service['jenkins'],
    }
    # There is the possibility someone removed the node from the
    # filesystem, if so only a restart (notify service) is required
    # because the template in init.groovy.d has not changed or will be created by puppet
    exec {"node: ${title} not available -> restart":
      command         => "echo node: ${title} not available -> restart jenkins",
      onlyif          => "test ! -f ${nodes_dir}/${title}/config.xml",
      path            => ['/usr/bin','/usr/sbin','/bin','/sbin'],
      notify  => Service['jenkins'],
    }
  }
  else {
    file {"${nodes_dir}/${title}":
      ensure => absent,
      force  => true,
      notify => Service['jenkins'],
    }
   file {"${init_dir}/${node_config_order}-node__${title}__.groovy":
      ensure => absent,
      notify  => Service['jenkins'],
    }
  }
}
