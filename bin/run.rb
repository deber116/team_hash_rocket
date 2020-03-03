require_relative '../config/environment'

puts "Hello! Sorry to keep you waiting! Welcome to the world of POKEMON!
My name is OAK. People call me the POKEMON PROF."

puts "\nThis world is inhabited by creatures that we call POKEMON.
People and POKEMON live together by supporting each other.
Some people play with POKEMON, some battle with them."

puts "\nBut we don't know everything about POKEMON yet. There are still
many mysteries to solve. That's why I study POKEMON every day."

puts "\nNow, what did you say your name was?"

name = gets.chomp

trainer = Trainer.find_or_create_by(name: name)

puts "#{trainer.name}, what would you like to do now?"
puts %q(
Your options are:
    1. Look for pokemon
    2. List all pokemon
    3. View your team of pokemon
)
puts "(Enter the number of the option you'd like)"
selection = gets.chomp.to_i

if selection == 1
    # Return a random pokemon from the db
    pokemon = Pokemon.all.sample
    puts "A wild #{pokemon.name} appeared! Do you want to catch it? (y/n)"
    response = gets.chomp

    if response == 'y' || response == 'yes'
        trainer.catch(pokemon)
    else
        puts "You idiot"
    end

# elsif selection == 2
    # TODO

end

binding.pry
