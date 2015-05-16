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
# Type jenkins::credentials_domain::username_password_credentials
#
# Jenkins credentials_domain (via the CloudBees Credentials plugin, which is installed by default)
# Generate UUID: ruby -e "require 'securerandom'; puts SecureRandom.uuid"
#
define jenkins::credentials_domain::username_password (
  $id = $title,
  $domain = $title,
  $scope = 'SYSTEM',
  $username = undef,
  $password = undef,
  $description = 'Managed by puppet!',
  $ensure = 'present',
  ) {

  $init_dir = $jenkins::params::init_dir
  $credentials_config_order = $jenkins::params::credentials_config_order

  validate_string($id)
  validate_string($domain)
  validate_string($scope)
  validate_string($username)
  validate_string($password)
  validate_string($description)

  Class['Jenkins::Config']-> Jenkins::Credentials_domain::Username_password[$title]

  # this is for the global domain
  if $domain == '$+=global+=$' {
    file{"${init_dir}/${credentials_config_order}-credentials__${id}__.groovy":
      ensure => $ensure,
      content => template('jenkins/credentials_username_password.groovy.erb'),
      owner => $::jenkins::params::username,
      group => $::jenkins::params::group,
      notify => Service['jenkins'],
    }
  }

  else {
    file{"${init_dir}/${credentials_config_order}-credentials__${id}__.groovy":
      ensure => $ensure,
      content => template('jenkins/credentials_username_password.groovy.erb'),
      owner => $::jenkins::params::username,
      group => $::jenkins::params::group,
      notify => Service['jenkins'],
      require => Jenkins::Credentials_domain[$domain]
    }
  }
}
