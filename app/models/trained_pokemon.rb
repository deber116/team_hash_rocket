class TrainedPokemon < ActiveRecord::Base
    belongs_to :trainer
    belongs_to :pokemon
    has_one :type, through: :pokemon

    def to_s
        "#{self.nickname} (#{self.pokemon.name})"
    end
end
