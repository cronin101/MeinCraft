require 'yaml'
require 'httparty'
require 'json'
require 'uri'

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
    {
      'client_id' => @client_key,
      'api_key' => @api_key
    }
  end

  def get_droplets
    uri = URI.parse DROPLETS_URI
    uri.query = URI.encode_www_form auth_params
    response = HTTParty.get uri
    droplets = JSON.parse(response.body)["droplets"]
  end

  def master_droplet
    get_droplets.select { |droplet| droplet["name"] == MASTER_NAME }[0]
  end

  def sizes
    uri = URI.parse SIZES_URI
    uri.query = URI.encode_www_form auth_params
    response = HTTParty.get uri.to_s
    possible_sizes = JSON.parse(response.body)["sizes"]
  end

  def images
    uri = URI.parse IMAGES_URL
    uri.query = URI.encode_www_form auth_params
    response = HTTParty.get uri.to_s
    possible_sizes = JSON.parse(response.body)["images"]
  end

  def create_slave
    config = YAML.load_file(CONFIG)['slave']
    uri = URI.parse (DROPLETS_URI + '/new')
    params = {
      'name' => config['name'],
      'size_id' => config['size_id'],
      'image_id' => config['image_id']
    }.merge auth_params
    uri.query = URI.encode_www_form params
    response = HTTParty.get uri.to_s
    created_droplet = JSON.parse(response.body)
  end

end
