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

define jenkins::plugins::publish_over_ssh::config (
  $hostname = $title,
  $username = undef,
  $password = undef,
  $passphrase = undef,
  $private_key_string = undef,
  $remote_root_dir = '/',
  $port = '22',
  $timeout = '300000',
  $override_key = true,
  $disable_exec = false,
  $ensure = 'present',
  ) {

  validate_string($name)
  validate_string($hostname)
  validate_string($username)
 #validate_string($password)

  Class['Jenkins::Plugins::Publish_over_ssh'] -> Jenkins::Plugins::Publish_over_ssh::Config["${title}"]

  $init_dir = $jenkins::params::init_dir
  $plugin_config_configs_order = $jenkins::params::plugin_config_configs_order
  $config_file_path = "${jenkins::params::home_dir}/${jenkins::plugins::publish_over_ssh::config_file}"

  # file {"${init_dir}/${plugin_config_configs_order}-plugin__publish-over-ssh_${title}__config.groovy":
  #   ensure  => $ensure,
  #   content => template("jenkins/publish_over_ssh_plugin_config.groovy.erb"),
  #   owner   => $jenkins::params::username,
  #   group   => $jenkins::params::group,
  #   mode    => '0600',
  #   notify  => Service['jenkins'],
  # }

  # ### BEGIN: RESOURCE DEFAULT -- jenkins_augeas
  # # Set a default for the jenkins_augeas resource
  # Jenkins_Augeas {
  #   incl => "${config_file_path}",
  #   context => "/files/${config_file_path}/jenkins.plugins.publish__over__ssh.BapSshPublisherPlugin_-Descriptor/hostConfigurations/",
  #   notify => Service['jenkins'],
  #   require => Class['Jenkins::Plugins::Publish_over_ssh']
  # }
  # ### END: RESOURCE DEFAULT -- jenkins_augeas


  # jenkins_augeas { "${config_file_path}--configuring publish_over_ssh plugin: ${title}":
  #   changes => [
  #               "set jenkins.plugins.publish__over__ssh.BapSshHostConfiguration[name/#text = \"${title}\"]/name/#text \"${name}\"",
  #               "defnode credentials_node jenkins.plugins.publish__over__ssh.BapSshHostConfiguration[name/#text = \"${title}\"] \"\"",
  #               "set \$credentials_node/hostname/#text \"${hostname}\"",
  #               "set \$credentials_node/username/#text \"${username}\"",
  #               "eset \$credentials_node/secretPassword/#text \"${password}\"",
  #               "set \$credentials_node/remoteRootDir/#text \"${remote_root_dir}\"",
  #               "set \$credentials_node/port/#text \"${port}\"",
  #               "set \$credentials_node/timeout/#text \"${timeout}\"",
  #               "set \$credentials_node/overrideKey/#text \"${override_key}\"",
  #               "set \$credentials_node/disableExec/#text \"${disable_exec}\"",
  #               ],
  # }

  # if $passphrase != undef {
  #   validate_string($private_key_string)
  #   jenkins_augeas { "${config_file_path}--configuring publish_over_ssh plugin: ${title} -- passphrase":
  #     changes => [
  #                 "defnode credentials_node jenkins.plugins.publish__over__ssh.BapSshHostConfiguration[name/#text = \"${title}\"] \"\"",
  #                 "eset \$credentials_node/keyInfo/secretPassphrase/#text \"${passphrase}\"",
  #                 ],
  #     require => Jenkins_augeas["${config_file_path}--configuring publish_over_ssh plugin: ${title}"]
  #   }
  # }

  # if $private_key_string != undef {
  #   validate_string($private_key_string)
  #   jenkins_augeas { "${config_file_path}--configuring publish_over_ssh plugin: ${title} -- private-key":
  #     changes => [
  #                 "defnode credentials_node jenkins.plugins.publish__over__ssh.BapSshHostConfiguration[name/#text = \"${title}\"] \"\"",
  #                 "set \$credentials_node/keyInfo/key/#text \"${private_key_string}\"",
  #                 ],
  #     require => Jenkins_augeas["${config_file_path}--configuring publish_over_ssh plugin: ${title}"]
  #   }
  # }
}
