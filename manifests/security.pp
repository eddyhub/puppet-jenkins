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
# Class jenkins::security
#
# Jenkins security configuration
#
# This class purges all securityRealm settings before it sets the new one.
# TODO
# authorization_strategy should get its own class so it is possible to
# purge authorization_strategy before setting a new one. Also the
# classes users and user should be refactured at the same time.
#
class jenkins::security (
  $security_realm = 'ldap',
  $ldap_server_fqdn =  undef,
  $ldap_rootdn = undef,
  $ldap_user_search_base = '',
  $ldap_user_search = 'uid={0}',
  $ldap_password = undef,
  $ldap_cache_size = 10,
  $ldap_cache_ttl = 600,
  $ldap_display_name_attribute_name = 'displayname',
  $ldap_mail_address_attribute_name = 'mail',
  $authorization_strategy = 'project_matrix',
  ){
  validate_string($security_realm)
  validate_string($ldap_server_fqdn)
  validate_string($ldap_root_dn)
  validate_string($ldap_password)
  validate_string($ldap_user_search_base)
  validate_string($ldap_user_search)
  # Only available in stdlib >= v4
  # validate_integer($ldap_cache_size)
  # validate_integer($ldap_cache_ttl)
  validate_string($authorization_strategy)

  Class['Jenkins::Config']-> Class['Jenkins::Security']
  # Bring variables from $jenkins::params into local scope.
  $init_dir           = $jenkins::params::init_dir
  $security_config_order = $jenkins::params::security_config_order

  file {"${init_dir}/${security_config_order}-security.groovy":
    ensure => present,
    content => template("jenkins/security.groovy.erb"),
    owner   => $jenkins::params::username,
    group   => $jenkins::params::group,
    mode    => '0600',
    notify  => Service['jenkins'],
  }

}
