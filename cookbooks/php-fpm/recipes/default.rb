#
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php-fpm
# Recipe:: default
#
# Copyright 2011, Opscode, Inc.
#
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

service_provider = nil

case node['platform']
when 'ubuntu'
  if node['platform_version'].to_f <= 10.04
    # Configure Brian's PPA
    # We'll install php5-fpm from the Brian's PPA backports
    apt_repository "brianmercer-php" do
      uri "http://ppa.launchpad.net/brianmercer/php/ubuntu"
      distribution node['lsb']['codename']
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "8D0DC64F"
      action :add
    end
    # FIXME: apt-get update didn't trigger in above
    execute "apt-get update"
  end

  if node['platform_version'].to_f >= 13.10
    service_provider = ::Chef::Provider::Service::Upstart
  end
when 'debian'
  # Configure Dotdeb repos
  # TODO: move this to it's own 'dotdeb' cookbook?
  # http://www.dotdeb.org/instructions/
  if node.platform_version.to_f >= 7.0
    apt_repository "dotdeb" do
      uri "http://packages.dotdeb.org"
      distribution "stable"
      components ['all']
      key "http://www.dotdeb.org/dotdeb.gpg"
      action :add
    end
  elsif node.platform_version.to_f >= 6.0
    apt_repository "dotdeb" do
      uri "http://packages.dotdeb.org"
      distribution "squeeze"
      components ['all']
      key "http://www.dotdeb.org/dotdeb.gpg"
      action :add
    end
  else
    apt_repository "dotdeb" do
      uri "http://packages.dotdeb.org"
      distribution "oldstable"
      components ['all']
      key "http://www.dotdeb.org/dotdeb.gpg"
      action :add
    end
    apt_repository "dotdeb-php53" do
      uri "http://php53.dotdeb.org"
      distribution "oldstable"
      components ['all']
      key "http://www.dotdeb.org/dotdeb.gpg"
      action :add
    end
  end

when 'amazon', 'fedora', 'centos', 'redhat'
  unless platform?('centos', 'redhat') && node['platform_version'].to_f >= 6.4
    yum_key 'RPM-GPG-KEY-remi' do
      url 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
    end

    yum_repository 'remi' do
      description 'Remi'
      url node['php-fpm']['yum_url']
      mirrorlist node['php-fpm']['yum_mirrorlist']
      key 'RPM-GPG-KEY-remi'
      action :add
    end
  end
end

if node['php-fpm']['package_name'].nil?
	if platform_family?("rhel")
	  php_fpm_package_name = "php-fpm"
	else
	  php_fpm_package_name = "php5-fpm"
	end
else
	php_fpm_package_name = node['php-fpm']['package_name']
end

package php_fpm_package_name do
  action :upgrade
end

template node['php-fpm']['conf_file'] do
  source "php-fpm.conf.erb"
  mode 00644
  owner "root"
  group "root"
  notifies :restart, "service[php-fpm]"
end

if node['php-fpm']['service_name'].nil?
	php_fpm_service_name = php_fpm_package_name
else
	php_fpm_service_name = node['php-fpm']['service_name']
end

service "php-fpm" do
  provider service_provider if service_provider
  service_name php_fpm_service_name
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

if node['php-fpm']['pools']
  node['php-fpm']['pools'].each do |pool|
    php_fpm_pool pool[:name] do
      pool.each do |k, v|
        self.params[k.to_sym] = v
      end
    end
  end
end
