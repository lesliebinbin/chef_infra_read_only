#!/usr/bin/env ruby
require 'net/ping'
check = Net::Ping::External.new 'wiki.org'
wifi_connections = [
  {
    ssid: 'Zhibin',
    password: 'ZhibinHuang'
  },
  {
    ssid: 'TheCapital-L3',
    password: 'BNE-3conomy$'
  },
  {
    ssid: 'The SPACE',
    password: 'd SPACE 88'
  },
  {
    ssid: 'TheCapital-L4',
    password: 'BNE-3conomy$'
  }

]
unless check.ping?
  wifi_connections.each do |wifi_conn|
    ssid, password = wifi_conn.values_at(:ssid, :password)
    `raspi-config nonint do_wifi_ssid_passphrase #{ssid} #{password}`
    break if check.ping?
  end
end
