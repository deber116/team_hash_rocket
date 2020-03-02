require 'net/http'
require 'open-uri'
require 'json'
require_relative '../config/environment.rb'


API_BASE = 'https://pokeapi.co/api/v2/'


def get_pokemon_data(pokemon_id)
    
    uri = URI.parse(API_BASE + "pokemon/#{pokemon_id}")
    response = Net::HTTP.get_response(uri)
    
    # TODO: Validate that the request was successful
    
    data = JSON.parse(response.body)

    # Extract the pokemon's name
    pokemon_name = data['name']

    # Get the first 'type' hash, and extact that type's name
    first_type = data['types'].find { |type| type['slot'] == 1 }
    pokemon_type = first_type['type']['name']

    return pokemon_name, pokemon_type

end


50.times do |i|
    pokemon_name, pokemon_type = get_pokemon_data(i+1)  
    type = Type.find_or_create_by(name: pokemon_type)
    Pokemon.create(name: pokemon_name, type: type)
end
