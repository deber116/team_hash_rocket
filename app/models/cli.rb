def game_loop(trainer)
    while true do
        # Ask the trainer what action they would like to take
        choices = ["Look for wild pokemon", "View Pokedex", "View your team of pokemon","Teach moves to pokemon on your team", "Check what moves your pokemon have", "Evolve a pokemon on your team", "Trade one of your pokemon with another trainer","Quit"]
        selection = $prompt.select("#{trainer.name}, what would you like to do now?".yellow, choices)
    
        if selection == "Look for wild pokemon"
            look_for_wild_pokemon(trainer)
    
        elsif selection == "View Pokedex"
            view_pokedex(trainer)
    
        elsif selection == "View your team of pokemon"
            if trainer.trained_pokemons.count == 0
                puts "You don't have any members on your team yet. Go catch some pokemon!".red
            else
                trainer.list_team
            end
        elsif selection == "Teach moves to pokemon on your team"
            teach_pokemon_moves(trainer)

        elsif selection == "Check what moves your pokemon have"
            check_pokemon_moves(trainer)

        elsif selection == "Trade one of your pokemon with another trainer"
            trade_pokemon(trainer)
    
        elsif selection == "Evolve a pokemon on your team"
            # Ask which pokemon they'd like to evolve (List the pokemon on their team that can evolve)
            # If none can evolve, let them know that.
            evolvable_pokemon = trainer.get_evolvable_team_members
            if trainer.trained_pokemons.count == 0
                puts "You don't have any members on your team yet. Go catch some pokemon!".red
            elsif evolvable_pokemon.length == 0
                puts "None of the pokemon on your team can evolve. Go catch some new pokemon!".red
            else
                tp_to_evolve = $prompt.select("Which of your pokemon would you like to evolve?".yellow, evolvable_pokemon + ['None'])
                if tp_to_evolve == 'None'
                    next  # If they actually don't want to evolve any, just continue on.
                end
    
                # Get the next evolution(s) for the trained_pokeon to evolve
                next_evolutions = tp_to_evolve.pokemon.next_evolutions
                
                # If there is more than one option, have the trainer select the evolution they want
                if next_evolutions.length > 1
                    next_evolution = $prompt.select("Which evolution?".yellow, next_evolutions + ['None'])
                    if next_evolution == 'None'
                        next  # If they actually don't want to evolve it, just continue on.
                    end
                else
                    next_evolution = next_evolutions.first
                end
    
                # Evolve their pokemon and save it
                tp_to_evolve.pokemon = next_evolution
                tp_to_evolve.save
                puts "Congrats! #{tp_to_evolve.nickname} evolved into #{next_evolution.name.upcase}!".green
            end
        
        else
            break
        end
    end
end

def look_for_wild_pokemon(trainer)
    # Return a random pokemon from the db
    pokemon = Pokemon.all.sample
    response = $prompt.yes?("A wild #{pokemon.name.upcase} appeared! Do you want to catch it?".light_green)

    if response == true
        trainer.catch(pokemon)
    else
        puts "The pokemon got away!".red
    end
end

def view_pokedex(trainer)
    pokedex_commands = ["List all pokemon", "View pokemon by type"]
            command = $prompt.select("What would you like to check on your Pokedex?".yellow, pokedex_commands)
            if command == "List all pokemon"
                Pokemon.list_all
            elsif command == "View pokemon by type"
                types = Type.list_types_by_name
                type_str = $prompt.select("Which type would you like to view?".yellow, types)
                type = Type.find_by(name: type_str.downcase)
                Pokemon.list_all_by_type(type)
            end
end

def teach_pokemon_moves(trainer)
    if trainer.get_team.count == 0
        puts "You don't have any members on your team yet. Go catch some pokemon!".red

    else
        p_selection = $prompt.select("Which pokemon on your team would you like to teach a move?".yellow, trainer.get_team_choices_hash)
        t_pokemon = trainer.trained_pokemons[p_selection]

        if t_pokemon.trained_moves.count == 4
            response = $prompt.yes?("That pokemon already knows 4 moves. Would you like to delete one?".yellow)
            if response
                move_instances = t_pokemon.trained_moves
                move_names = t_pokemon.trained_moves_names
                move_hash = Hash[move_names.zip move_instances]
                result = $prompt.select("Which move would you like to delete?".yellow, move_hash)
                result.destroy
            end
        else 
            remaining_instances = t_pokemon.remaining_move_choice_instances
            remaining_names = t_pokemon.remaining_move_choice_names
            
            #creates hash of {move_name => move_instance}
            moves_hash = Hash[remaining_names.zip remaining_instances]
            
            #returns move instance that needs to be added
            selected_move_instance = $prompt.select("Which move would you like to teach this pokemon?".yellow, moves_hash)
            
            t_pokemon.add_move(selected_move_instance) 
        end
    end
end

def check_pokemon_moves(trainer)
    if trainer.get_team.count == 0
        puts "You don't have any members on your team yet. Go catch some pokemon!".red
    else
        check_pokemon_index = $prompt.select("Which pokemon would you like to check the moves of?".yellow,trainer.get_team_choices_hash)
        t_pokemon = trainer.trained_pokemons[check_pokemon_index]
        if trainer.trained_pokemons[check_pokemon_index].trained_moves_names.count == 0
            puts "This pokemon doesn't have any moves yet. Teach it some moves!".yellow
        else
            puts "Here are the moves that #{t_pokemon.nickname} knows.".yellow
            puts trainer.trained_pokemons[check_pokemon_index].trained_moves_names
        end
    end
end

def trade_pokemon(trainer)
    if trainer.trained_pokemons.size < 1
        puts "You don't have any pokemon to trade yet, go out and catch some!".red
    else
    other_trainers = Trainer.all - [trainer]
    trainer_selection = $prompt.select("Which trainer would you like to trade with?".yellow, other_trainers)
    pokemon_selection = $prompt.select("Which of #{trainer_selection.name}'s pokemon would you like to trade?".yellow, trainer_selection.trained_pokemons)
    pokemon_to_trade = $prompt.select("Which of your pokemon would you like to swap with this #{pokemon_selection}?".yellow, trainer.trained_pokemons)
    pokemon_selection.trainer = trainer
    pokemon_selection.save
    trainer.trained_pokemons.reset
    pokemon_to_trade.trainer = trainer_selection
    pokemon_to_trade.save
    trainer_selection.trained_pokemons.reset
    end
end

