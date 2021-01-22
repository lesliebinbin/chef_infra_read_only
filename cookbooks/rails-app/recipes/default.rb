#
# Cookbook:: rails-app
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe '::sys_base'
template '/etc/systemd/system/rails-app.service' do
  source 'rails-app-service.erb'
end

git 'pi-scanning-programs' do
  repository 'a private github repo for pi program'
  destination '/home/pi/pi-devices-programs'
  action [:sync]
  user 'pi'
  group 'pi'
end

execute 'install-bundle' do
  command 'cd /home/pi/pi-devices-programs; bundle install'
  user 'pi'
  group 'pi'
  # subscribes :run, 'git[pi-scanning-programs]', :immediately
  action :nothing
end

service 'rails-app' do
  action %i[start enable]
  # subscribes :restart, 'execute[install-bundle]', :immediately
end

include_recipe '::find3_cli_download'

gem_package 'net-ssh' do
  version '6.1.0'
end

template '/home/pi/keys.pem' do
  source node[:spaceitapp][:remote_ssh][:pem_template]
  owner 'pi'
  group 'pi'
  mode '0400'
end

template '/home/pi/ssh_forward' do
  source 'ssh_forward.erb'
  owner 'pi'
  group 'pi'
  mode '0700'
end

template '/etc/systemd/system/ssh_forward_ec2.service' do
  source 'ssh-forward-ec2.service.erb'
  owner 'pi'
  group 'pi'
  mode '0700'
end

template '/etc/network/interfaces' do
  source 'interfaces.erb'
end

template '/etc/wpa_supplicant/wpa_supplicant.conf' do
  source 'wpa_supplicant.conf.erb'
end

service 'ssh_forward_ec2' do
  action %i[enable]
end

template '/etc/systemd/system/space-power.service' do
  source 'space-power.service.erb'
end

service 'space-power' do
  action %i[start enable]
end

cookbook_file '/home/pi/ssh_via_mqtt' do
  source 'ssh_via_mqtt.rb'
  mode '0755'
end

template '/etc/systemd/system/ssh-via-mqtt.service' do
  source 'ssh-via-mqtt.service.erb'
end

service 'ssh-via-mqtt' do
  action %i[enable start]
end

cookbook_file '/home/pi/ubertooth_ipc' do
  source 'ubertooth_ipc.rb'
  mode '0755'
end

template '/etc/systemd/system/ubertooth-ipc.service' do
  source 'ubertooth-ipc.service.erb'
end

service 'ubertooth-ipc' do
  action %i[enable start]
end

cron 'swith-to-ubertooth-day-mode' do
  command 'systemctl restart ubertooth-ipc '
  hour 5
  minute 5
  user 'root'
end

cron 'swith-to-ubertooth-day-mode' do
  command 'systemctl restart ubertooth-ipc '
  hour 20
  minute 5
  user 'root'
end

include_recipe '::pi_monitor'
include_recipe '::auth_manage'
include_recipe '::check_network'
include_recipe '::rsync'
