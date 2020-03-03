class Move < ActiveRecord::Base
    has_many :pokemons, through: :pokemon_moves
    has_many :trained_pokemons, through: :trained_pokemon_moves
end
