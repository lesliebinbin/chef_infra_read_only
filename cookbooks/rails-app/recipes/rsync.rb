cron 'rsync-log-file' do
  command %(rsync -avz -e "ssh -i /home/pi/keys.pem" /var/log/* #{node[:spaceitapp][:remote_ssh][:user]}@#{node[:spaceitapp][:remote_ssh][:host]}:/home/ubuntu/pi-devices-logs/#{node[:name]}/)
  hour '*/1'
  action :delete
end

template '/home/pi/dmesg_print' do
  source 'dmesg_print.erb'
  mode '0700'
end

cron 'post_kernel_info' do
  command '/home/pi/dmesg_print'
  minute '*/5'
end
