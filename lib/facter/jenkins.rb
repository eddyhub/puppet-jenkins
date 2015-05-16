require 'facter'

# jenkins.rb
#
# Creates a fact 'jenkins_plugins' containing a comma-delimited string of all
# jenkins plugins + versions.
#
#
#require 'puppet/jenkins/facts'

# If we're being loaded inside the module, we'll need to go ahead and add our
# facts then won't we?
#Puppet::Jenkins::Facts.install

Facter.add(:jenkins_home_dir) do
  setcode do
    begin
      File.expand_path('~jenkins')
    rescue ArgumentError => ex
      # The Jenkins user doesn't exist so there is no home dir!
      nil
    end
  end
end

Facter.add(:jenkins_plugins_dir) do
  setcode do
    begin
      File.join(File.expand_path('~jenkins'), 'plugins')
    rescue ArgumentError => ex
      # The Jenkins user doesn't exist so there is no home dir!
      nil
    end
  end
end
