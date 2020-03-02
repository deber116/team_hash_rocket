class TrainedPokemon < ActiveRecord::Base
    belongs_to :trainer
    belongs_to :pokemon
    has_one :type, through: :pokemon
end