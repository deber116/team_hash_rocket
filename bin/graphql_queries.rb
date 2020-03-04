# require_relative '../config/environment.rb'
# require "graphql/client"
# require "graphql/client/http"



# #module POKE
#     # variables = { "pokemonId" => "1"}
#     # id = 1
#     API_BASE = 'https://pokeapi.co/api/v2/'
#     HttpAdapter = GraphQL::Client::HTTP.new(API_BASE + 'pokemon/1') do
#         #def headers(context)
#         # end
#     end
#     Schema = GraphQL::Client.load_schema(HttpAdapter)
#     Client = GraphQL::Client.new(schema: Schema, execute: HttpAdapter)
# #end
# #PokemonSchema.execute(query_string, variables: variables)

# PokemonQuery = POKE::Client.parse <<-'GRAPHQL'
# query {
#     name
# }
# GRAPHQL

# binding.pry