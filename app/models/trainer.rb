class Trainer < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :pokemons, through: :trained_pokemons

end