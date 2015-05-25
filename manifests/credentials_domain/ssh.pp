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
# Type jenkins::credentials_domain::ssh
#
# Jenkins credentials_domain (via the CloudBees Credentials plugin, which is installed by default)
# Generate UUID: ruby -e "require 'securerandom'; puts SecureRandom.uuid"
#

define jenkins::credentials_domain::ssh (
  $id = $title,
  $ensure = 'present',
  $domain = undef,
  $scope = 'SYSTEM',
  $username = undef,
  $passphrase = undef,
  $private_key_string = undef,
  $description = 'Managed by puppet!',
  ) {

  $init_dir = $jenkins::params::init_dir
  $credentials_config_order = $jenkins::params::credentials_config_order

  validate_string($id)
  validate_string($domain)
  validate_string($scope)
  validate_string($username)
  validate_string($passphrase)
  validate_string($private_key_string)
  validate_string($description)
  validate_re($scope, ['^SYSTEM$', '^GLOBAL$'])
  validate_re($ensure, ['^present$', '^absent$'])

  Class['Jenkins::Config']-> Jenkins::Credentials_domain::Ssh[$title]

  # this is for the global domain
  if $domain == undef {
    file{"${init_dir}/${credentials_config_order}-credentials__${id}__.groovy":
      ensure => $ensure,
      content => template('jenkins/credentials_ssh.groovy.erb'),
      owner => $::jenkins::params::username,
      group => $::jenkins::params::group,
      notify => Service['jenkins'],
    }
  }

  else {
    file{"${init_dir}/${credentials_config_order}-credentials__${id}__.groovy":
      ensure => $ensure,
      content => template('jenkins/credentials_ssh.groovy.erb'),
      owner => $::jenkins::params::username,
      group => $::jenkins::params::group,
      notify => Service['jenkins'],
      require => Jenkins::Credentials_domain[$domain]
    }
  }
}
