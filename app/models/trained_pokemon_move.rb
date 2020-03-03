class TrainedPokemonMove < ActiveRecord::Base
    belongs_to :trained_pokemon
    belongs_to :move
end
