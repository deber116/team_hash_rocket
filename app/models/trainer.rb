class Trainer < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :pokemons, through: :trained_pokemons

    def catch(pokemon)
        if self.trained_pokemons.count < 6
            puts "You caught a #{pokemon.name}!\nWhat would you like to nickname it?"
            nickname = gets.chomp
            TrainedPokemon.create(nickname: nickname, trainer: self, pokemon: pokemon)
            puts "Congrats #{self.name}, #{nickname} has been added to your team!"
        else
            puts "You have too many pokemon. Would you like to release one of the pokemon on your team? (y/n)"
            self.release
            puts ""
        end
    end

    def release
        puts "Which pokemon on your team would you like to release?"
        team = self.list_team
        puts "Please select the pokemon by number"
        response = gets.chomp.to_i
        team[response - 1].destroy
    end

    def list_team
        i = 1
        self.trained_pokemons.reset
        self.trained_pokemons.each do |tp|
            puts "#{i}.) #{tp.nickname} (#{tp.pokemon.name})"
            i += 1
        end
    end
end
