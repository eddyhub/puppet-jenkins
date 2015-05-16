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
# Type jenkins::plugins::job_direct_mail::config
#

define jenkins::plugins::job_direct_mail::config (
  $text = undef,
  $add_project_name = true,
  $add_url = true,
  $add_build_status = true,
  $ensure = 'present',
  ) {

  validate_string($text)
  validate_bool($add_project_name)
  validate_bool($add_url)
  validate_bool($add_build_status)

  Class['Jenkins::Plugins::Job_direct_mail'] -> Jenkins::Plugins::Job_direct_mail::Config["${title}"]
  $config_file_path = "${jenkins::params::home_dir}/${jenkins::plugins::job_direct_mail::config_file}"

  jenkins_augeas { "${config_file_path}--configuring job_direct_mail plugin: ${title}":
    incl => "${config_file_path}",
    context => "/files/${config_file_path}/org.jenkinsci.plugins.jobmail.configuration.JobMailGlobalConfiguration/templates/",
    changes => [
                "set org.jenkinsci.plugins.jobmail.configuration.JobMailGlobalConfiguration_-Template[name/#text = \"${title}\"]/name/#text \"${name}\"",
                "defnode template_node org.jenkinsci.plugins.jobmail.configuration.JobMailGlobalConfiguration_-Template[name/#text = \"${title}\"] \"\"",
                "set \$template_node/addProjectName/#text \"${add_project_name}\"",
                "set \$template_node/addUrl/#text \"${add_url}\"",
                "set \$template_node/addBuildStatus/#text \"${add_build_status}\"",
                ],
    notify => Service['jenkins'],
    require => Class['Jenkins::Plugins::Job_direct_mail']
  }
}
