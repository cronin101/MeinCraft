#!/usr/bin/env ruby

require 'gli'
include GLI::App

require './digital_ocean_api.rb'

DO = DigitalOceanAPI.new

def perform_command_on(target, command)
  action = "ssh #{DO.slave['username']}@#{target['ip_address']} '#{command}'"
  puts action
  `#{action}`
end

def transfer_file_to(target, file)
  command = "scp #{file} #{DO.slave['username']}@#{target['ip_address']}:~"
  puts command
  `#{command}`
end


def kill_screens(slave)
  puts "Closing all active screen sessions"
  puts (perform_command_on slave, 'screen -ls | grep "Detached" | awk "{print $1}" | xargs -i screen -X -S {} quit')
end

def reset_from_master
  slave = DO.slave_droplet

  kill_screens(slave)

  puts "Clearing snapshot data..."
  perform_command_on slave, 'rm -r ~/server'


  puts "Restoring from latest backup..."
  transfer_file_to slave, './server.tar.bz2'
  puts "Extracting..."
  perform_command_on slave, 'tar -jxvf ~/server.tar.bz2'

  puts "Creating screen session with minecraft server..."
  puts (perform_command_on slave, "cd server; screen -d -m 'export RAM=#{DO.slave['ram']}; ./be_server.sh'")
end

command :this do |c|
  c.action do
    puts "This droplet: #{DO.master_droplet}"
  end
end

command :sizes do |c|
  c.action do
    puts "Available sizes: #{DO.sizes}"
  end
end

command :images do |c|
  c.action do
    puts "Available images: #{DO.images}"
  end
end

command :deploy do |c|
  c.action do
    DO.create_slave
    puts "Waiting for slave creation..."
    60.times { sleep 1; print '.'; $stdout.flush }
    puts
    reset_from_master
  end
end

command :reset do |c|
  c.action do
    reset_from_master
  end
end

command :destroy do |c|
  c.action do
    puts DO.destroy_slave.inspect
  end
end

command :slave do |c|
  c.action do
    slave = DO.slave_droplet
    if slave.nil?
      puts "No slave exists."
    else
      puts slave.inspect
    end
  end
end

exit run(ARGV)
