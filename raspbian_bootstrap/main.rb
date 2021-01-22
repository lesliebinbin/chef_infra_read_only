#!/usr/bin/env ruby
require 'yaml'
require 'json'
threads = []
YAML.load_file('raspi-config.yml')['nodes'].each do |node|
  threads << Thread.new do
    json_attr = node['attrs'].to_json
    bootstrap_cmd = %(knife bootstrap #{node['ip']} -t raspbian_bootstrap.erb -r "#{node['recipes']}" -N #{node['name']} -U #{node['user']} -P #{node['password']} -j '#{json_attr}' --sudo --yes)
    system(bootstrap_cmd)
  end
end
threads.each(&:join)
