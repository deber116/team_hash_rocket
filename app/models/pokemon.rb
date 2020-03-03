class Pokemon < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :trainers, through: :trained_pokemons
    belongs_to :type

    def self.list_all
        Pokemon.all.each_with_index do |pokemon, i|
            puts "#{i+1}. #{pokemon}"
        end
    end

    def to_s
        "#{self.name.upcase} (type: #{self.type.name.upcase})"
    end
end