class Pokemon < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :trainers, through: :trained_pokemons
    belongs_to :type
    has_many :pokemon_moves
    has_many :moves, through: :pokemon_moves
    has_many :next_evolutions, class_name: "Pokemon", foreign_key: "previous_evolution_id"
    belongs_to :previous_evolution, class_name: "Pokemon"

    def self.list_all
        Pokemon.all.each_with_index do |pokemon, i|
            puts "#{i+1}. #{pokemon}"
        end
    end

    def to_s
        "#{self.name.upcase} (type: #{self.type.name.upcase})"
    end

    def self.list_all_by_type(type)
        of_type = Pokemon.all.select { |pokemon| pokemon.type == type }
        puts "All #{type.name} type Pokemon:"
        of_type.each_with_index { |pokemon, i| puts "#{i+1}. #{pokemon.name.upcase}" }
    end
    
    def is_evolvable?
        self.next_evolutions.length > 0
    end
end
