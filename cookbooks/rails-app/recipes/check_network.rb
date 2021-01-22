cron 'check_the_network' do
  command 'ping -c 4 wiki.org && touch /home/pi/network_status'
  minute '*/2'
end

cookbook_file '/home/pi/detect_network' do
  source 'detect_network.rb'
  mode '0755'
end

cron 'check_and_reset_network_if_necessary' do
  command '/home/pi/detect_network && ifconfig wlan0 down && ifconfig wlan0 up'
  minute '*/10'
  user 'root'
end

cookbook_file '/home/pi/check_network' do
  source 'check_network_status.rb'
  mode '0755'
end

cron 'switch_network_if_necessary' do
  command '/home/pi/check_network'
  minute '*/3'
  user 'root'
  action :delete
end
