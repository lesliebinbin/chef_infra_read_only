#!/usr/bin/env ruby
require 'rest-client'
require 'json'
uber_fifo = '/home/pi/ipcs/ubertooth-fifo'
uber_command = 'ubertooth-rx -z -e 0 -t 1800'

fork do
  loop do
    File.open(uber_fifo) do |f|
      f.each_line do |line|
        begin
          RestClient.post 'http://localhost:3000/ubertooth', { line: line }.to_json, { content_type: :json, accept: :json }
        rescue StandardError => e
          puts e.message
        end
      end
    end
  end
end

loop do
  status = system("#{uber_command} > #{uber_fifo} 2>&1")
  sleep 2 unless status
end
