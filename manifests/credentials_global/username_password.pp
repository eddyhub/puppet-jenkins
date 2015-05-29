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
# Type jenkins::credentials_global::username_password
#
# Jenkins credentials_domain (via the CloudBees Credentials plugin, which is installed by default)
# Generate UUID: ruby -e "require 'securerandom'; puts SecureRandom.uuid"
#

define jenkins::credentials_global::username_password (
  $id = $title,
  $scope = 'SYSTEM',
  $username = undef,
  $password = undef,
  $description = "${title} is managed by puppet!",
  $ensure = 'present',
  ) {

  jenkins::credentials_domain::username_password {$id:
    domain => '$+=global+=$',
    scope => $scope,
    username => $username,
    password => $password,
    description => $description,
    ensure => $ensure,
  }
}
