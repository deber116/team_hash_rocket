class Trainer < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :pokemons, through: :trained_pokemons

    def add_trained_pokemon(pokemon)
        nickname = $prompt.ask("What would you like to nickname it?".yellow)
        TrainedPokemon.create(nickname: nickname, trainer: self, pokemon: pokemon)
        puts "Congrats #{self.name}, #{nickname} has been added to your team!".light_green
    end

    def catch(pokemon)

        if self.trained_pokemons.count >= 6
            response = $prompt.yes?("You have too many pokemon. Would you like to release one of the pokemon on your team?".yellow)
            
            if response == true
                self.release
                puts "You caught a #{pokemon.name}!".light_green
                self.add_trained_pokemon(pokemon)
            else 
                puts "The pokemon got away!".red
            end
        
        else
            puts "You caught a #{pokemon.name}!".light_green
            self.add_trained_pokemon(pokemon)
        end
    end

    def release
        team = self.list_team
        tp_to_release = $prompt.select("Which pokemon on your team would you like to release?".yellow, team)
        tp_to_release.destroy
        puts "#{tp_to_release.nickname} was released.".yellow
    end

    def list_team
        self.trained_pokemons.reset
        self.trained_pokemons.each_with_index do |trained_pokemon, i|
            puts "#{i+1}. #{trained_pokemon}"
        end
    end

    #returns the team array without puts-ing it
    def get_team
        self.trained_pokemons.reset
        self.trained_pokemons.map do |tp|
            "#{tp}"
        end
    end

    def get_team_choices_hash
        result = {}
        self.trained_pokemons.each_with_index do |tp, i|
            result[tp] = i
        end
        result
    end
end


