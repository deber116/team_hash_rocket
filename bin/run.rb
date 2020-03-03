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
    choices = ["Look for wild pokemon", "List all pokemon", "View your team of pokemon","Quit"]
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
    else
        break
    end
end
