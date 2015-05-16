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
# Type jenkins::credentials_domain
#
# Jenkins credentials_domain (via the CloudBees Credentials plugin, which is installed by default)
# Generate UUID: ruby -e "require 'securerandom'; puts SecureRandom.uuid"
#
define jenkins::credentials_domain (
  $description = "Domain ${title} is managed by puppet!",
  # Actually all this specifications can be included multiple times. I
  # don't know why this should be possibe because in jenkins you can
  # specify all in one line.
  $hostname_specification_include_list = undef,
  $hostname_specification_exclude_list = undef,
  $hostname_port_specification_include_list = undef,
  $hostname_port_specification_exclude_list = undef,
  $path_specification_include_list = undef,
  $path_specification_exclude_list = undef,
  $path_specification_case_sensitive = false,
  $scheme_specification_list = undef,
  ) {

  validate_string($name)
  validate_string($description)
  validate_bool($path_specification_case_sensitive)

  Class['Jenkins::Config']-> Jenkins::Credentials_domain[$title]

  $init_dir = $jenkins::params::init_dir
  $credentials_domain_config_order = $jenkins::params::credentials_domain_config_order

  file{"${init_dir}/${credentials_domain_config_order}-credentials-domain__${name}__.groovy":
    ensure => present,
    content => template('jenkins/credentials_domain.groovy.erb'),
    owner => $::jenkins::params::username,
    group => $::jenkins::params::group,
    notify => Service['jenkins'],
  }
}
