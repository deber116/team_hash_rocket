require 'open-uri'
require 'net/http'
require 'json'
require_relative '../../config/environment.rb'

BASE = 'https://pokeapi.co/api/v2/'

def get_move_data
    
    uri = URI.parse(BASE + "pokemon/1")
    response = Net::HTTP.get_response(uri)

    data = JSON.parse(response.body)

    move_list = data["moves"]
    move_list = move_list.map do |move|
        move["move"]["name"]
    end

    
end

result = get_move_data

binding.pry

result