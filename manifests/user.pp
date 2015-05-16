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
# Type jenkins::user
#
# A Jenkins user account
# TODOs
# -implement more than project_matrix as authorization strategy
# -users should be purged automaticaly if they aren't defined: One way
# is to create a class jenkins:users and add the possibility to pass a
# hash ({user00->{permissionXXX}, user01->{permissionXXX}} which uses
# the function create_resources and passes this ressource and the hash
# as a parameters (see: class jenkins::users).
# -write more documentation
#
define jenkins::user (
  $user_id                                       = $title,
  $email                                         = undef,
  $password                                      = undef,
  $full_name                                     = 'Managed by Puppet',
  $public_key                                    = undef,
  $description                                   = 'Managed by Puppet',
  $ensure                                        = present,
  ){

  $init_dir          = $jenkins::params::init_dir
  $users_dir         = $jenkins::params::users_dir
  $user_config_order = $jenkins::params::user_config_order

  if $ensure == 'present' {
    file {"${init_dir}/${user_config_order}-user__${user_id}__.groovy":
      ensure => present,
      content => template("jenkins/user.groovy.erb"),
      owner   => $jenkins::params::username,
      group   => $jenkins::params::group,
      mode    => '0600',
      notify  => Service['jenkins'],
    }
    # There is the possibility someone removed the user from the
    # filesystem, if so only a restart (notify service) is required
    # because the template in init.groovy.d has not changed or will be created by puppet
    exec {"user: ${user_id} not available -> restart":
      command         => "echo user: ${name} not available -> restart jenkins",
      onlyif          => "test ! -f ${users_dir}/${user_id}/config.xml",
      path            => ['/usr/bin','/usr/sbin','/bin','/sbin'],
      notify  => Service['jenkins'],
    }
  }
  else {
    file {"${users_dir}/${user_id}":
      ensure => absent,
      force  => true,
      notify => Service['jenkins'],
    }

    file {"${init_dir}/${user_config_order}-user__${user_id}__.groovy":
      ensure => absent,
      notify  => Service['jenkins'],
    }
  }
}
