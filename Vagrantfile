# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "DJenkinsDev/VagrantPHP"
  config.vm.box_version = "0.4.0"
  config.vm.box_check_update = true

  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=666"]

  # Port Forwarding for:
  ## NginX
  config.vm.network "forwarded_port", guest: 80, host: 8080
  ## MySQL
  config.vm.network "forwarded_port", guest: 3306, host: 33060
  ## MongoDB
  config.vm.network "forwarded_port", guest: 27017, host: 20017
  ## Redis
  config.vm.network "forwarded_port", guest: 6379, host: 63790
  
  # Allow more memory and fix this problem : http://askubuntu.com/questions/238040/how-do-i-fix-name-service-for-vagrant-client
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end
