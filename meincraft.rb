#!/usr/bin/env ruby

require 'gli'
include GLI::App

require './lib/digital_ocean_api.rb'
require './lib/slave_driver.rb'
require './lib/rinetd.rb'

DO = DigitalOceanAPI.new

def create_slave
  DO.create_slave
  puts 'Waiting for slave creation...'
  60.times { sleep 1; print '.'; $stdout.flush }
  puts
end

def reset(slave)
  sd = SlaveDriver.new(DO.slave['username'], slave['ip_address'], DO.slave['mc_ram'])
  sd.reset_from_master

  RINETD.redirect_port_to slave['ip_address']
  RINETD.restart
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
    slave = DO.slave_droplet
    if slave.nil?
      create_slave

      new_slave = DO.slave_droplet

      reset new_slave
    else
      puts "Slave already exists: #{slave}"
    end
  end
end

command :reset do |c|
  c.action do
    slave = DO.slave_droplet
    if slave.nil?
      puts 'No slave exists to reset.'
    else
      reset slave
    end
  end
end

command :destroy do |c|
  c.action do
    slave = DO.slave_droplet
    if slave.nil?
      puts 'No slave exists to destroy.'
    else
      sd = SlaveDriver.new(DO.slave['username'], slave['ip_address'])

      sd.kill_sessions

      sd.clone_from_slave

      puts DO.destroy_slave.inspect
    end
  end
end

command :clone do |c|
  c.action do
    slave = DO.slave_droplet
    if slave.nil?
      puts 'No slave exists to clone.'
    else
      sd = SlaveDriver.new(DO.slave['username'], slave['ip_address'])

      sd.kill_sessions

      sd.clone_from_slave
    end
  end
end

command :slave do |c|
  c.action do
    slave = DO.slave_droplet
    if slave.nil?
      puts 'No slave exists.'
    else
      puts slave.inspect
    end
  end
end

exit run(ARGV)
