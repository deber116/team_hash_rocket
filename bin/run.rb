require_relative '../config/environment'

puts "Hello! Sorry to keep you waiting! Welcome to the world of POKEMON!
My name is OAK. People call me the POKEMON PROF."

puts "\nThis world is inhabited by creatures that we call POKEMON.
People and POKEMON live together by supporting each other.
Some people play with POKEMON, some battle with them."

puts "\nBut we don't know everything about POKEMON yet. There are still
many mysteries to solve. That's why I study POKEMON every day."
puts ''

# Get the Trainer's name. Convert their input to Title Case (e.g. "eLlis aNdReWs" --> "Ellis Andrews")
name = $prompt.ask("Now, what did you say your name was? =>") { |q| q.modify :collapse, :trim, :down }.titleize 

# Find an existing trainer or create a new one if none exists in the database
trainer = Trainer.find_or_create_by(name: name)

while true do
    # Ask the trainer what action they would like to take
    choices = ["Look for wild pokemon", "View Pokedex", "View your team of pokemon","Teach moves to pokemon on your team","Check what moves your pokemon have","Quit"]
    selection = $prompt.select("#{trainer.name}, what would you like to do now?", choices)

    if selection == "Look for wild pokemon"
        # Return a random pokemon from the db
        pokemon = Pokemon.all.sample
        response = $prompt.yes?("A wild #{pokemon.name} appeared! Do you want to catch it?")

        if response == true
            trainer.catch(pokemon)
        else
            puts "The pokemon got away!"
        end

    elsif selection == "View Pokedex"

        pokedex_commands = ["List all pokemon", "View pokemon by type"]
        command = $prompt.select("What would you like to check on your Pokedex?", pokedex_commands)
        if command == "List all pokemon"
            Pokemon.list_all
        elsif command == "View pokemon by type"
            types = Type.list_types_by_name
            type_str = $prompt.select("Which type would you like to view?", types)
            type = Type.find_by(name: type_str)
            Pokemon.list_all_by_type(type)
        end

    elsif selection == "View your team of pokemon"
        trainer.list_team
    elsif selection == "Teach moves to pokemon on your team"
        if trainer.get_team.count == 0
            puts "You don't have any members on your team yet. Go catch some pokemon!"

        else
            p_selection = $prompt.select("Which pokemon on your team would you like to teach a move?", trainer.get_team_choices_hash)
            t_pokemon = trainer.trained_pokemons[p_selection]

            if t_pokemon.trained_moves.count == 4
                response = $prompt.yes?("That pokemon already knows 4 moves. Would you like to delete one?")
                if response
                    move_instances = t_pokemon.trained_moves
                    move_names = t_pokemon.trained_moves_names
                    move_hash = Hash[move_names.zip move_instances]
                    result = $prompt.select("Which move would you like to delete?", move_hash)
                    binding.pry
                    result.destroy
                end
            else 
                remaining_instances = t_pokemon.remaining_move_choice_instances
                remaining_names = t_pokemon.remaining_move_choice_names
                #remaining_move_choice_names = t_pokemon.get_moves_names.first(10) - t_pokemon.trained_moves_names
                #remaining_move_choice_instances = t_pokemon.get_available_moves - t_pokemon.trained_moves.map {|tm| tm.move}
                
                #creates hash of {move_name => move_instance}
                moves_hash = Hash[remaining_names.zip remaining_instances]
                
                #returns move instance that needs to be added
                selected_move_instance = $prompt.select("Which move would you like to teach this pokemon?", moves_hash)
                
                t_pokemon.add_move(selected_move_instance) 
            end
        end
    elsif selection == "Check what moves your pokemon have"
        if trainer.get_team.count == 0
            puts "You don't have any members on your team yet. Go catch some pokemon!"
        else
            check_pokemon_index = $prompt.select("Which pokemon would you like to check the moves of?",trainer.get_team_choices_hash)
            puts trainer.trained_pokemons[check_pokemon_index].trained_moves_names
        end
    else
        break
    end
end
