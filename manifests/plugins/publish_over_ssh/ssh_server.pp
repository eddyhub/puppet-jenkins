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
# Type jenkins::plugins::publish_over_ssh::config

define jenkins::plugins::publish_over_ssh::ssh_server (
  $hostname = $title,
  $username = 'root',
  $password_passphrase = undef,
  $private_key_string = undef,
  $remote_root_dir = '/',
  $port = '22',
  $timeout = '300000',
  $disable_exec = false,
  $ensure = 'present',
  ) {

  validate_string($name)
  validate_string($hostname)
  validate_string($username)

  if $password_passphrase != undef or $private_key_string != undef {
    $override_key = true
  }
  else {
    $override_key = false
  }
  Class['Jenkins::Plugins::Publish_over_ssh'] -> Jenkins::Plugins::Publish_over_ssh::Ssh_server["${title}"]

  $init_dir = $jenkins::params::init_dir
  $plugin_config_configs_order = $jenkins::params::plugin_config_configs_order
  $config_file_path = "${jenkins::params::home_dir}/${jenkins::plugins::publish_over_ssh::config_file}"

  file {"${init_dir}/${plugin_config_configs_order}-plugin__publish-over-ssh_configure_ssh_server_${title}__config.groovy":
    ensure  => present,
    content => template("jenkins/publish_over_ssh_plugin_ssh_server_config.groovy.erb"),
    owner   => $jenkins::params::username,
    group   => $jenkins::params::group,
    mode    => '0600',
    notify  => Service['jenkins'],
  }
}
