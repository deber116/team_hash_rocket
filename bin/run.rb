require_relative '../config/environment'

pikachu = <<-pika
                                   ,'\\
    _.----.        ____         ,'  _\\   ___    ___     ____
_,-'       `.     |    |  /`.   \\,-'    |   \\  /   |   |    \\  |`.
\\      __    \\    '-.  | /   `.  ___    |    \\/    |   '-.   \\ |  |
 \\.    \\ \\   |  __  |  |/    ,','_  `.  |          | __  |    \\|  |
   \\    \\/   /,' _`.|      ,' / / / /   |          ,' _`.|     |  |
    \\     ,-'/  /   \\    ,'   | \\/ / ,`.|         /  /   \\  |     |
     \\    \\ |   \\_/  |   `-.  \\    `'  /|  |    ||   \\_/  | |\\    |
      \\    \\ \\      /       `-.`.___,-' |  |\\  /| \\      /  | |   |
       \\    \\ `.__,'|  |`-._    `|      |__| \\/ |  `.__,'|  | |   |
        \\_.-'       |__|    `-._ |              '-.|     '-.| |   |
                                `'                            '-._|
pika
puts pikachu

puts "Hello! Sorry to keep you waiting! Welcome to the world of POKEMON!
My name is OAK. People call me the POKEMON PROF.".light_magenta

puts "\nThis world is inhabited by creatures that we call POKEMON.
People and POKEMON live together by supporting each other.
Some people play with POKEMON, some battle with them.".light_magenta

puts "\nBut we don't know everything about POKEMON yet. There are still
many mysteries to solve. That's why I study POKEMON every day.".light_magenta
puts ''

# Get the Trainer's name. Convert their input to Title Case (e.g. "eLlis aNdReWs" --> "Ellis Andrews")
name = $prompt.ask("Now, what did you say your name was? =>".cyan) { |q| q.modify :collapse, :trim, :down }.titleize 

# Find an existing trainer or create a new one if none exists in the database
trainer = Trainer.find_or_create_by(name: name)

game_loop(trainer)
