require 'yaml'
require 'httparty'
require 'json'

class DigitalOceanAPI
  CONFIG = './config.yml'

  BASE_URI = 'https://api.digitalocean.com'
  DROPLETS_URI = BASE_URI + '/droplets/'
  SIZES_URI = BASE_URI + '/sizes/'
  IMAGES_URI = BASE_URI + '/images/'

  MASTER_NAME = 'SuicuneNouveau'

  def initialize
    credentials = YAML.load_file(CONFIG)['creds']
    @client_key = credentials['client']
    @api_key = credentials['api']
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

  def sizes
    response = HTTParty.get(SIZES_URI + "?#{auth_params}")
    possible_sizes = JSON.parse(response.body)["sizes"]
  end

  def images
    response = HTTParty.get(IMAGES_URI + "?#{auth_params}")
    possible_sizes = JSON.parse(response.body)["images"]
  end

  def create_slave
    config = YAML.load_file(CONFIG)['slave']
    params = "/new?"
    params << "name=#{config['name']}"
    params << "&size_id=#{config['size_id']}"
    params << "&image_id=#{config['image_id']
    response = HTTParty.get(DROPLETS_URI + params + "&#{auth_params}")
  end

end
