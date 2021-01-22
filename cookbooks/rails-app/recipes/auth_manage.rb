directory '/home/pi/.ssh' do
  user 'pi'
  group 'pi'
end
template '/home/pi/.ssh/id_rsa' do
  source 'id_rsa.erb'
  owner 'pi'
  group 'pi'
  mode '0600'
  action :create_if_missing
end

template '/home/pi/.ssh/id_rsa.pub' do
  source 'id_rsa.pub.erb'
  owner 'pi'
  group 'pi'
  mode '0600'
  action :create_if_missing
end


ruby_block 'change the password' do
  block do
    require 'open3'
    Open3.popen3 'passwd pi' do |stdin, _stdout, _stderr, _wait_thr|
      stdin.puts 'Some Password'
      stdin.puts 'Some Password'
    end
  end
end

execute 'restart-the-sshd' do
  command 'service ssh restart'
  action :nothing
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  notifies :run, 'execute[restart-the-sshd]', :delayed
end
