class Trainer < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :pokemons, through: :trained_pokemons

    def catch(pokemon)
        p "You caught a #{pokemon.name}!\nWhat would you like to nickname it?"
        nickname = gets.chomp
        TrainedPokemon.create(nickname: nickname, trainer: self, pokemon: pokemon)
        p "Congrats #{self.name}, #{nickname} has been added to your team!"
    end
    
end