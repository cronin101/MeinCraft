#!/usr/bin/env ruby

require 'gli'
include GLI::App

require './digital_ocean_api.rb'

DO = DigitalOceanAPI.new

command :this do |c|
  c.action do
    puts "This droplet: #{DO.master_droplet}"
  end
end

command :sizes do |c|
  c.action do
    puts "Available sizes: #{DO.get_sizes}"
  end
end

command :images do |c|
  c.action do
    puts "Available images: #{DO.get_images}"
  end
end

command :deploy do |c|
  c.action do
    DO.create_slave
    puts "Waiting for slave creation"
    60.times { sleep 1; print '.'; $stdout.flush }
    puts
    puts DO.slave_droplet
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
