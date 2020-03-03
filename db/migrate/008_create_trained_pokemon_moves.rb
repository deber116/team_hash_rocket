class CreateTrainedPokemonMoves < ActiveRecord::Migration[5.2]

    def change
        create_table :trained_pokemon_moves do |t|
            t.integer :move_id
            t.integer :trained_pokemon_id
        end
    end

end
