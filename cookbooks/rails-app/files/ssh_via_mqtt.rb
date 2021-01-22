#!/usr/bin/env ruby
require 'mqtt'
require 'rest-client'
require 'json'

mqtt_conn = {
  host: 'some aws mqtt host'
  port: 8883,
  ssl: true,
  cert_file: 'cert file download from aws mqtt service',
  key_file: 'key file',
  ca_file: 'ca file'
}

network_status = {}

begin
    mqtt_client = MQTT::Client.connect mqtt_conn
    unless network_status.empty?
      network_status[:end] = Time.now
      if (network_status[:end] - network_status[:start]) > 600
        RestClient.post(
          'some team web hook url',
          { text: "#{`hostname`.chomp} is back, network_down_status: #{network_status}" }.to_json,
          { content_type: :json, accept: :json }
        )
      end
      network_status.clear
    end
    mqtt_client.subscribe('remote/forward/ec2', 'pi/remote_command')

    mqtt_client.get do |topic, message|
      message = JSON.parse(message, symbolize_names: true)
      case topic
      when 'remote/forward/ec2'
        hostname, action = message.values_at(:hostname, :action)
        host_name_local = `hostname`.chomp
        if hostname == host_name_local
          result = `sudo systemctl #{action} ssh_forward_ec2`
          RestClient.post(

            'some team web hook url',
            { text: "#{hostname} #{action} executed and the result is #{result}" }.to_json,
            { content_type: :json, accept: :json }
          )
        end
      when 'pi/remote_command'

        hostname, command = message.values_at(:hostname, :command)
        host_name_local = `hostname`.chomp

        if hostname == host_name_local
          RestClient.post(
            'some team web hook url',
            { text: "#{hostname} #{command} is about to be executed" }.to_json,
            { content_type: :json, accept: :json }
          )
          system(command)
        end

      end
    end
rescue StandardError, MQTT::ProtocolException => e
  puts e.message
  network_status[:start] = Time.now if network_status.empty?
  sleep 3
  retry
  end
