# -*- mode: ruby -*-
# vi: set ft=ruby :

$puppet_install = <<SCRIPT
  if [ ! -x /usr/bin/puppet ]; then
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    yum install -y puppet
  fi
SCRIPT

$bats_install = <<SCRIPT
if [ ! -x /usr/local/bin/bats ]; then
  cd /tmp
  rm -rf bats
  wget -q -O v0.4.0.tar.gz https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz
  tar xzf v0.4.0.tar.gz
  cd bats-0.4.0
  ./install.sh /usr/local
fi
SCRIPT

$bats_run = <<SCRIPT
/usr/local/bin/bats /vagrant/bats
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-nocm"

  config.vm.provision 'shell', inline: $puppet_install
  config.vm.provision 'shell', inline: $bats_install

  config.vm.provision "puppet" do |puppet|
    puppet.module_path    = [ '..', 'modules' ]
    puppet.options        = '--verbose --debug' if ENV['VAGRANT_DEBUG']
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "vagrant.pp"
  end

  config.vm.provision 'shell', inline: $bats_run
end
