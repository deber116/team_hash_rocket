class CreatePokemons < ActiveRecord::Migration[5.2]
    def change
        create_table :pokemons do |t|
            t.string :name
            t.integer :type_id
        end
    end
end