class Pokemon < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :trainers, through: :trained_pokemons
    belongs_to :type
end