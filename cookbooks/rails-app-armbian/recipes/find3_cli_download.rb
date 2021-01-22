remote_file '/usr/local/bin/find3-cli-scanner' do
  source 'https://space-pi-devices.s3-ap-southeast-2.amazonaws.com/find3-cli-scanner'
  mode '0755'
  action :create
end
