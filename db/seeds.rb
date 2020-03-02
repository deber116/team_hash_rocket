require 'open-uri'
require 'net/http'

#API_BASE = "https://pokeapi.co/"


#url = API_BASE + 
#uri = URI.parse(url)

Trainer.destroy_all
Pokemon.destroy_all
Type.destroy_all
TrainedPokemon.destroy_all

elec = Type.create(name: "electric")
pikachu = Pokemon.create(name: "Pikachu",type: elec)
ash = Trainer.create(name: "Ash")

trained = TrainedPokemon.create(nickname: "testy", pokemon: pikachu, trainer: ash)