require_relative "../config/environment.rb"

puts "Which pokemon would you like to know more about?"
poke = gets.chomp

result = Pokemon.find_by(name: poke)

puts "#{result.name} is a #{result.type.name} type"