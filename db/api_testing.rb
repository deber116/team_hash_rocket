require 'net/http'
require 'open-uri'
require 'json'
require_relative '../config/environment.rb'


API_BASE = 'https://pokeapi.co/api/v2/'


def get_evolutions(evolution_chain_id)
    uri = URI.parse(API_BASE + "evolution-chain/#{evolution_chain_id}")
    response = Net::HTTP.get_response(uri)
    
    # TODO: Validate that the request was successful
    
    data = JSON.parse(response.body)

    # Extract the chain base pokemon's name and call for type
    base_pokemon_name = data['chain']['species']['name']

    get_base_pokemon = URI.parse(API_BASE + "pokemon/#{base_pokemon_name}")

    base_pokemon_response = Net::HTTP.get_response(get_base_pokemon)
    base_pokemon_data = JSON.parse(base_pokemon_response.body)

    base_pokemon_first_type = base_pokemon_data['types'].find { |type| type['slot'] == 1 }
    base_pokemon_type = base_pokemon_first_type['type']['name']
    chain_type = Type.find_or_create_by(name: base_pokemon_type)
    Pokemon.create(name: base_pokemon_name, type: chain_type)
    #if data['evolves_to'] != []
    binding.pry

end

5.times do |i|
    get_evolutions(i + 1)
end
