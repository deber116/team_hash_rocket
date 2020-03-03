class AddNextEvolutionIdToPokemons < ActiveRecord::Migration[5.2]
    def change
        add_column :pokemons, :next_evolution_id, :integer
    end
end