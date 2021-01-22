#!/usr/bin/env ruby
require 'net/ping'
exit(1) if (Time.now - File.mtime('/home/pi/network_status')) < 5 * 60
