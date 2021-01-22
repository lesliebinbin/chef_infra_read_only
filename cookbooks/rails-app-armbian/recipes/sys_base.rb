hostname node[:spaceitapp][:host]
ENV['DEBIAN_FRONTEND'] = 'noninteractive'

apt_package_lambda = lambda { |_|
  options '--yes --allow-downgrades --allow-remove-essential --allow-unauthenticated'
}

gem_package_lambda = lambda { |_|
  version '2.1.4'
}

%w[openssl
   autoconf
   automake
   libtool
   libreadline-dev
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

chef_gem 'rest-client' do
  version '2.1.0'
end
chef_gem 'macaddr' do
  version '1.7.2'
end
chef_gem 'jwt' do
  version '2.2.2'
end
