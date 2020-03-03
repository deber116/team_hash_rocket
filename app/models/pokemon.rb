class Pokemon < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :trainers, through: :trained_pokemons
    belongs_to :type

    def self.list_all
        Pokemon.all.each do |poke|
            puts "species: #{poke.name.upcase}, type: #{poke.type.name.upcase}"
        end
    end
end