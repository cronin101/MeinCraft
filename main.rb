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
    puts "Available sizes: #{DO.sizes}"
  end
end

command :images do |c|
  c.action do
    puts "Available images: #{DO.images}"
  end
end

command  :deploy do |c|
  c.action do
    DO.create_slave
  end
end

exit run(ARGV)
