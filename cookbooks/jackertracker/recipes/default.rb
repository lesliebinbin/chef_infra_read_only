#
# Cookbook:: jackertracker
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

ENV['DEBIAN_FRONTEND'] = 'noninteractive'

apt_package_lambda = lambda { |_|
  options '--yes --allow-downgrades --allow-remove-essential --allow-unauthenticated'
}

%w[python3
   python3-dev].each do |pkg|
  apt_package pkg, &apt_package_lambda
end

apt_package 'python3-pip' do
  options '--yes --allow-downgrades --allow-remove-essential --allow-unauthenticated'
  notifies :run, 'execute[install-trackerjacker]', :delayed
end

execute 'install-trackerjacker' do
  command 'pip3 install trackerjacker; pip3 install requests'
  action :nothing
end

directory '/home/pi/jackass-plugins' do
  action :create
  recursive true
end

template '/home/pi/jackass-plugins/space_plugin.py' do
  source 'space_plugin.py.erb'
end

template '/etc/systemd/system/trackerjacker.service' do
  source 'trackerjacker.service.erb'

  # notifies :restart, 'service[trackerjacker]', :delayed
end

service 'trackerjacker' do
  action %i[stop]
end
