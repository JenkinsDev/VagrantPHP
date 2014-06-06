# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "DJenkinsDev/VagrantPHP"
  config.vm.box_version = "0.2.0"
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
end
