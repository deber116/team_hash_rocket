class AddPreviousEvolutionIdToPokemons < ActiveRecord::Migration[5.2]
    def change
        add_column :pokemons, :previous_evolution_id, :integer
    end
end
