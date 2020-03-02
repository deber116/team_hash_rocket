class CreateTrainedPokemons < ActiveRecord::Migration[5.2]
    def change
        create_table :trained_pokemons do |t|
            t.string :nickname
            t.integer :pokemon_id
            t.integer :trainer_id
        end
    end
end