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
    choices = ["Look for wild pokemon", "List all pokemon", "View your team of pokemon","Teach moves to pokemon on your team","Check what moves your pokemon have","Quit"]
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

    elsif selection == "List all pokemon"
        Pokemon.list_all
    elsif selection == "View your team of pokemon"
        trainer.list_team
    elsif selection == "Teach moves to pokemon on your team"
        if trainer.get_team.count == 0
            puts "You don't have any members on your team yet. Go catch some pokemon!"

        else
            p_selection = $prompt.select("Which pokemon on your team would you like to teach a move?", trainer.get_team_choices_hash)
            t_pokemon = trainer.trained_pokemons[p_selection]

            if t_pokemon.trained_moves.count == 4
                puts "That pokemon already knows 4 moves. You can't teach it anymore"
            else 
                move_names = t_pokemon.get_moves_names.first(10) - t_pokemon.trained_moves_names
                binding.pry
                result = {}
                move_names.each_with_index {|name, i| result[name] = i }
                
                result_index = $prompt.select("Which move would you like to teach this pokemon?", result)
                selected_move = t_pokemon.pokemon.moves.first(10)[result_index]
                t_pokemon.add_move(selected_move) 
            end
        end
    elsif selection == "Check what moves your pokemon have"
        
    else
        break
    end
end
