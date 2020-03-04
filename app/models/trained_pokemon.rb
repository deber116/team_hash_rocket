class TrainedPokemon < ActiveRecord::Base
    belongs_to :trainer
    belongs_to :pokemon
    has_one :type, through: :pokemon
    has_many :trained_pokemon_moves
    has_many :moves, through: :trained_pokemon_moves
    
    def to_s
        "#{self.nickname} (#{self.pokemon.name})"
    end

    def get_moves_names
        move_names = self.pokemon.moves.map {|move| move.name}
    end

    def add_move(move)
        self.moves << move
    end

    def trained_moves
        self.trained_pokemon_moves
    end

    def trained_moves_names
        self.trained_moves.map {|trained_move| trained_move.move.name}
    end
end
