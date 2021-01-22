template '/home/pi/monitor.sh' do
  source 'monitor-service.erb'
  owner 'pi'
  group 'pi'
  mode '0700'
end

template '/home/pi/monitor_send' do
  source 'monitor_send.erb'
  owner 'pi'
  group 'pi'
  mode '0700'
end

cron 'raspberry_pi_runtime_monitor' do
  action :create
  minute 30
  command '/home/pi/monitor_send'
end
