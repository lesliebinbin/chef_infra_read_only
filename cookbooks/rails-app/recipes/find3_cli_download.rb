if platform?('raspbian')
  remote_file '/usr/local/bin/find3-cli-scanner' do
    source 'some url of s3 bucket'
    mode '0755'
    action :create
  end

  if node['network']['interfaces'].keys.grep(/wlx/).first
    template '/etc/systemd/system/find3-scanner.service' do
      source 'find3-scanner-service.erb'
      # notifies :reload, 'service[find3-scanner]', :delayed
      # notifies :restart, 'service[find3-scanner]', :delayed
    end

    service 'find3-scanner' do
      action %i[stop disable]
    end
  end

end
