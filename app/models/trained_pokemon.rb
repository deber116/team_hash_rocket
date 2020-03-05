class TrainedPokemon < ActiveRecord::Base
    belongs_to :trainer
    belongs_to :pokemon
    has_one :type, through: :pokemon
    has_many :trained_pokemon_moves
    has_many :moves, through: :trained_pokemon_moves
    
    def to_s
        "#{self.nickname} (#{self.pokemon.name})"
    end

    def get_available_moves
        self.pokemon.moves.reset
        self.pokemon.moves.first(10)
    end
    #moves that are available to this pokemon from moves table. Filtered for first 10 results
    def get_moves_names
        self.pokemon.moves.reset
        move_names = self.pokemon.moves.map {|move| move.name}.first(10)
    end

    #ties a given move to the trained_pokemon via the trained_pokemon_moves table
    def add_move(move)
        self.moves << move
    end

    #returns the trained_pokemon's trained moves from the trained_pokemon_moves table
    def trained_moves
        self.trained_pokemon_moves.reset
        self.trained_pokemon_moves
    end

    #returns an array of strings of the trained moves' names
    def trained_moves_names
        self.trained_moves.map {|trained_move| trained_move.move.name}
    end

    #returns an array of move name strings that can be assigned to a trained pokemon
    def remaining_move_choice_names
        a_moves = self.get_available_moves.map {|m| m.name}.first(10)
        a_moves - self.trained_moves_names
    end

    #returns an array of move instances that can be assigned to a trained pokemon
    def remaining_move_choice_instances
        self.get_available_moves - self.trained_moves.map {|tm| tm.move}
    end

    #used to seed trainer pokemon, fills 4 move slots
    def fill_move_slots
        moves = get_available_moves.sample(4)
        moves.each { |move| self.add_move(move) }
    end
end
