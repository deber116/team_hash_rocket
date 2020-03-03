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

    #create type instance for pokemon in evolution chain and a base pokemon instance
    chain_type = Type.find_or_create_by(name: base_pokemon_type)
    base_pokemon = Pokemon.create(name: base_pokemon_name, type: chain_type)
    chain = data['chain']['evolves_to']
    if chain[0]
        base_pokemon.next_evolution_id = base_pokemon.id + 1
        base_pokemon.save
    end

    until chain[0] == nil
        evolved_pokemon_name = chain[0]['species']['name']
        evolved_pokemon = Pokemon.create(name: evolved_pokemon_name, type: chain_type)
        chain = chain[0]['evolves_to']
        if chain[0]
            evolved_pokemon.next_evolution_id = evolved_pokemon.id + 1
            evolved_pokemon.save
        end
    end

end



5.times do |i|
    get_evolutions(i + 1)
end
