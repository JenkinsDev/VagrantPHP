# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # VM Box
  config.vm.box = "hashicorp/precise64"

  # Port forwarding to NginX
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # REQUIRES Users to have the Omnibus Vagrant package installed.
  config.omnibus.chef_version = :latest

  ### Provisioning!
  # We will go ahead and make sure we run apt-get update before
  # running any other provisions. This way we are always updated with
  # urls.
  config.vm.provision "shell", inline: "apt-get update"

  # Provision our software with chef solo!
  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "ohai"
    chef.add_recipe "nginx::source"
    chef.add_recipe "php55-cookbook"
    chef.add_recipe "php-fpm"

    chef.log_level = :debug
 
    chef.json = {
      :nginx => {
        :version => "1.7.0"
      },
      :mysql_password => "foo"
    }
  end
  ### End Provisioning
end
