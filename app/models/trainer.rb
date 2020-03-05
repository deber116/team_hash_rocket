class Trainer < ActiveRecord::Base
    has_many :trained_pokemons
    has_many :pokemons, through: :trained_pokemons

    def add_trained_pokemon(pokemon)
        nickname = $prompt.ask("What would you like to nickname it?")
        TrainedPokemon.create(nickname: nickname, trainer: self, pokemon: pokemon)
        puts "Congrats #{self.name}, #{nickname} has been added to your team!"
    end

    def catch(pokemon)

        if self.trained_pokemons.count >= 6
            response = $prompt.yes?("You have too many pokemon. Would you like to release one of the pokemon on your team?")
            
            if response == true
                self.release
                puts "You caught a #{pokemon.name}!"
                self.add_trained_pokemon(pokemon)
            else 
                puts "The pokemon got away!"
            end
        
        else
            puts "You caught a #{pokemon.name}!"
            self.add_trained_pokemon(pokemon)
        end
    end

    def release
        team = self.list_team
        tp_to_release = $prompt.select("Which pokemon on your team would you like to release?", team)
        tp_to_release.destroy
        puts "#{tp_to_release.nickname} was released."
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

    def get_evolvable_team_members
        self.trained_pokemons.reset
        self.trained_pokemons.select { |tp| tp.pokemon.is_evolvable? }
    end

end
