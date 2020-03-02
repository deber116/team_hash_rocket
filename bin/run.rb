require_relative '../config/environment'

puts "Hello! Sorry to keep you waiting! Welcome to the world of POKEMON!
My name is OAK. People call me the POKEMON PROF."

puts "This world is inhabited by creatures that we call POKEMON.
People and POKEMON live together by supporting each other.
Some people play with POKEMON, some battle with them."

puts "But we don't know everything about POKEMON yet. There are still
many mysteries to solve. That's why I study POKEMON every day."

puts "Now, what did you say your name was?"

name = gets.chomp

t = Trainer.create(name: name)

game_loop(t)