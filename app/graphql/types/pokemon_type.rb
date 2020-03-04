module Types

    class Types::BaseObject < GraphQL::Schema::Object 
    end

    class PokemonType < Types::BaseObject
        description "A single pokemon"
        field :id, ID, null: false
        field :name, String, null: false
        #field :type, String, null: false
    end
end