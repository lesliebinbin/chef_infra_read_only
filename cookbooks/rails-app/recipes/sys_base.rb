hostname node[:spaceitapp][:host]
ENV['DEBIAN_FRONTEND'] = 'noninteractive'

apt_package_lambda = lambda { |_|
  options '--yes --allow-downgrades --allow-remove-essential --allow-unauthenticated'
}

gem_package_lambda = lambda { |_|
  version '2.1.4'
}

if platform?('raspbian')
  %w[rpi-update pi-bluetooth].each do |pkg|
    apt_package pkg, &apt_package_lambda
  end
end

%w[openssl
   autoconf
   automake
   libtool
   libreadline-dev
   network-manager
   wireless-tools
   net-tools
   libpcap-dev
   bluetooth
   libgdbm-dev
   ruby
   ruby-dev
   bison
   libmariadbclient-dev
   automake
   git
   curl
   zlib1g-dev
   subversion
   git-core
   zlib1g
   libssl-dev
   libbluetooth3
   libbluetooth-dev
   ubertooth].each do |pkg|
  apt_package pkg, &apt_package_lambda
end

chef_gem 'bundler', &gem_package_lambda

gem_package 'bundler', &gem_package_lambda
gem_package 'net-ping' do
  version '2.0.8'
end

chef_gem 'rest-client' do
  version '2.1.0'
end
chef_gem 'macaddr' do
  version '1.7.2'
end
chef_gem 'jwt' do
  version '2.2.2'
end

gem_package 'rest-client' do
  version '2.1.0'
end

gem_package 'mqtt' do
  version '0.5.0'
end

gem_package 'chronic' do
  version '0.10.2'
end

file '/home/pi/area-id' do
  content '123456789'
  action :create_if_missing
  owner 'pi'
  group 'pi'
end

file '/home/pi/device-id' do
  content '123456789'
  action :create_if_missing
  owner 'pi'
  group 'pi'
end

directory '/home/pi/network_down' do
  user 'pi'
  group 'pi'
end

file '/home/pi/family' do
  content node[:spaceitapp][:family]
  owner 'pi'
  group 'pi'
end

file '/home/pi/device' do
  content node[:spaceitapp][:device]
  owner 'pi'
  group 'pi'
end

file '/home/pi/location' do
  content node[:spaceitapp][:location]
  owner 'pi'
  group 'pi'
end
