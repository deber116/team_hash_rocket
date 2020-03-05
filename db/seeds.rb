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


def validate_api_response(response)
    # Validate that an API request was successful
    case response
    when Net::HTTPSuccess then
        response
    else
        raise response.value
    end
end


def get_pokemon_data(pokemon_name)
    # Make a request to the pokemon's endpoint
    uri = URI.parse(API_BASE + "pokemon/#{pokemon_name}")
    response = Net::HTTP.get_response(uri)

    # Check that the request was successful
    response = validate_api_response(response)

    # Return the parsed response body (a hash)
    JSON.parse(response.body)
end


def get_evolution_chain_data(evolution_chain_id)
    # Make a request to the evolution chain's endpoint
    uri = URI.parse(API_BASE + "evolution-chain/#{evolution_chain_id}")
    response = Net::HTTP.get_response(uri)
    
    # Check that the request was successful
    response = validate_api_response(response)
    
    # Return the parsed response body (a hash)
    JSON.parse(response.body)
end


def add_pokemon_to_database(pokemon_name, previous_evolution)
    # Function takes a pokemon name string and previous_evolution Pokemon

    # Make and API request for the pokemon, and use that to create Pokemon, Type, and Move objects
    pokemon_data = get_pokemon_data(pokemon_name)

    # Extract the name of the first of the pokemon's types, and add a Type to the DB if it doesn't already exist
    first_type = pokemon_data['types'].find { |type| type['slot'] == 1 }
    first_type_name = first_type['type']['name']
    type = Type.find_or_create_by(name: first_type_name)

    # Extract the pokemon's name, and add a Pokemon to the DB
    pokemon_name = pokemon_data['name']
    pokemon = Pokemon.create(name: pokemon_name, type: type, previous_evolution: previous_evolution)

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


def recursively_process_evolution_chain(evolution_chain, previous_evolution=nil)
    # Function takes an `evolution_chain` hash and a `previous_evolution` Pokemon and processes it to completion

    # Extract the pokemon's name string
    pokemon_name = evolution_chain['species']['name']  
    
    # Create Pokemon, Type, and Move objects for the Pokemon
    pokemon = add_pokemon_to_database(pokemon_name, previous_evolution)

    # Extract the evolves to array of hashes
    evolves_to = evolution_chain['evolves_to']
    
    # Iterate through each evolution chain in the `evolves_to` array
    evolves_to.each { |chain| recursively_process_evolution_chain(chain, pokemon) }
end


def add_pokemon_data_by_evolution_chain_id(evolution_chain_id)

    # Make and API request for the evolution chain
    evolution_chain_data = get_evolution_chain_data(evolution_chain_id)

    # Extract the top-level chain (a hash)
    top_level_chain = evolution_chain_data['chain']

    # Recursively process the top-level chain and all sub-chains
    recursively_process_evolution_chain(top_level_chain)
end


100.times do |i| 
    add_pokemon_data_by_evolution_chain_id(i + 1) 
    sleep(2)  # Sleep 2 seconds to avoid going over our API request rate limit. This is approximate!
end

25.times do
    r_t = random_trainer
    team = Pokemon.all.sample(6)
    team.each do |poke|
        poke_name = random_pokemon_nickname
        t_p = TrainedPokemon.create(nickname: poke_name, trainer: trainer, pokemon: poke)
        t_p.fill_move_slots
    end
end

def random_trainer
    rando = Faker::Name.name
    trainer = Trainer.create(name: rando)
end

def random_pokemon_nickname
    nicknames = [Faker::Creature::Horse.name,
        Faker::Books::Lovecraft.deity,
        Faker::Creature::Cat.name,
        Faker::Creature::Dog.name,
        Faker::Superhero.prefix
        ]
    nicknames.sample
end