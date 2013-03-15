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
  REGIONS_URI = BASE_URI + '/regions/'

  RESOURCES = %w{droplets sizes images regions}

  MASTER_NAME = 'SuicuneNouveau'

  def initialize
    load_config
  end

  def load_config
    config = YAML.load_file(CONFIG)
    credentials = config['creds']
    @client_key = credentials['client']
    @api_key = credentials['api']

    @slave = config['slave']
  end

  def auth_params
    {
      'client_id' => @client_key,
      'api_key' => @api_key
    }
  end

  def get_object_from_location(object_name, location)
    uri = URI.parse location
    uri.query = URI.encode_www_form auth_params
    response = HTTParty.get uri.to_s
    droplets = JSON.parse(response.body)[object_name]
  end

  def named_object(name, objects)
    objects.select { |object| object['name'] == name }[0]
  end

  RESOURCES.each do |object|
    method_name = "get_#{object}"
    define_method(method_name) do
      location = self.class.const_get(object.upcase << "_URI")
      get_object_from_location(object, location)
    end
    method_name = "#{object}_called"
    define_method(method_name) do |name|
      named_object(name, self.send("get_#{object}"))
    end
  end

  def master_droplet
    named_object(MASTER_NAME, get_droplets)
  end

  def slave_droplet
    named_object(@slave['name'], get_droplets)
  end

  def create_slave
    uri = URI.parse (DROPLETS_URI + '/new')
    params = {
      'name' => @slave['name'],
      'size_id' => size_called(@slave['size'])['id'],
      'image_id' => image_called(@slave['image'])['id'],
      'region_id' => region_called(@slave['region'])['id']
    }.merge auth_params
    uri.query = URI.encode_www_form params
    response = HTTParty.get uri.to_s
    created_droplet = JSON.parse(response.body)
  end

  def destroy_slave
    uri = URI.parse (DROPLETS_URI + "/#{slave_droplet['id']}/destroy/")
    uri.query = URI.encode_www_form auth_params
    response = HTTParty.get uri.to_s
    destroyed_droplet = JSON.parse(response.body)
  end

end
