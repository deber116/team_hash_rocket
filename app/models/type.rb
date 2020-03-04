class Type < ActiveRecord::Base
    has_many :pokemons

    def self.list_types_by_name
        Type.all.map { |type| type.name }
    end
end