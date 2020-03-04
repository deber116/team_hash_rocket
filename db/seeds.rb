require 'net/http'
require 'open-uri'
require 'json'
require_relative '../config/environment.rb'


# TODO: Add sleep statments due to rate-limit API!

# Destroy all data in the database
models = [
    Move,
    PokemonMove,
    Pokemon,
    TrainedPokemonMove,
    TrainedPokemon,
    Trainer,
    Type
]

models.each { |model| model.destroy_all }



API_BASE = 'https://pokeapi.co/api/v2/'


def get_pokemon_data(pokemon_name)
    uri = URI.parse(API_BASE + "pokemon/#{pokemon_name}")
    response = Net::HTTP.get_response(uri)
    
    # TODO: Validate that the response was successful
    
    # Return the parsed response body (a hash)
    JSON.parse(response.body)
end


def get_evolution_chain_data(evolution_chain_id)
    # Make evolution chain request
    uri = URI.parse(API_BASE + "evolution-chain/#{evolution_chain_id}")
    response = Net::HTTP.get_response(uri)
    
    # TODO: Validate that the request was successful
    
    JSON.parse(response.body)
end


def add_pokemon_to_database(pokemon_name)
    # Function takes a pokemon name string

    # Make and API request for the pokemon, and use that to create Pokemon, Type, and Move objects
    pokemon_data = get_pokemon_data(pokemon_name)

    # Extract the name of the first of the pokemon's types, and add a Type to the DB if it doesn't already exist
    first_type = pokemon_data['types'].find { |type| type['slot'] == 1 }
    first_type_name = first_type['type']['name']
    type = Type.find_or_create_by(name: first_type_name)

    # Extract the pokemon's name, and add a Pokemon to the DB
    pokemon_name = pokemon_data['name']
    pokemon = Pokemon.create(name: pokemon_name, type: type)

    # Extract the moves, and add them to the DB along with a PokemonMove associating them with the Pokemon
    pokemon_moves = pokemon_data['moves']
    pokemon_moves.each do |pokemon_move|

        # Add a Move to the DB if it doesn't already exist
        move_name = pokemon_move['move']['name']
        move = Move.find_or_create_by(name: move_name)
        
        # Add a PokemonMove to the DB associating the Pokemon with the Move
        PokemonMove.create(pokemon: pokemon, move: move)
    end
    pokemon
end


def recursively_process_evolution_chain(evolution_chain)
    # Function takes an `evolution_chain` hash and processes it to completion

    # Extract the pokemon's name string
    pokemon_name = evolution_chain['species']['name']  
    
    # Create Pokemon, Type, and Move objects for the Pokemon
    pokemon = add_pokemon_to_database(pokemon_name)

    # Extract the evolves to array of hashes
    evolves_to = evolution_chain['evolves_to']
    
    # Iterate through each evolution chain in the `evolves_to` array
    evolves_to.each { |chain| recursively_process_evolution_chain(chain) }
end


def add_pokemon_data_by_evolution_chain_id(evolution_chain_id)

    # Make and API request for the evolution chain
    evolution_chain_data = get_evolution_chain_data(evolution_chain_id)

    # Extract the top-level chain (a hash)
    top_level_chain = evolution_chain_data['chain']

    # Recursively process the top-level chain and all sub-chains
    recursively_process_evolution_chain(top_level_chain)
end


5.times { |i| add_pokemon_data_by_evolution_chain_id(i + 1) }
