#!/usr/bin/env ruby

require 'yaml'
require 'httparty'
require 'json'

class DigitalOceanAPI
  CONFIG = './config.yml'

  BASE_URI = 'https://api.digitalocean.com'
  DROPLETS_URI = BASE_URI + '/droplets/'

  MASTER_NAME = 'SuicuneNouveau'

  def initialize
    credentials = YAML.load_file(CONFIG)['creds']
    @client_key = credentials['client']
    @api_key = credentials['api']
    puts "Loaded creds..."
    puts "Found _this_ droplet: " << master_droplet.inspect

  end

  def auth_params
    "client_id=#{@client_key}&api_key=#{@api_key}"
  end

  def get_droplets
    response = HTTParty.get(DROPLETS_URI + "?#{auth_params}")
    droplets = JSON.parse(response.body)["droplets"]
  end

  def master_droplet
    get_droplets.select { |droplet| droplet["name"] == MASTER_NAME }[0]
  end
end

DO = DigitalOceanAPI.new
