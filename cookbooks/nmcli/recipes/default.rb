#
# Cookbook:: nmcli
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

ENV['DEBIAN_FRONTEND'] = 'noninteractive'

apt_package_lambda = lambda { |_|
  options '--yes --allow-downgrades --allow-remove-essential --allow-unauthenticated'
}

%w[network-manager].each do |pkg|
  apt_package pkg, &apt_package_lambda
end
