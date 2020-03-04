class PokemonSchema < GraphQL::Schema
    #query(Types::QueryType)

    # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections

  # GraphQL::Batch setup:
  use GraphQL::Batch

  max_complexity 200
  max_depth 20
end