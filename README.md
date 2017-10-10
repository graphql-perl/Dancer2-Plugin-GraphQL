# NAME

Dancer2::Plugin::GraphQL - a plugin for adding GraphQL route handlers

# SYNOPSIS

    package MyWebApp;

    use Dancer2;
    use Dancer2::Plugin::GraphQL;
    use GraphQL::Schema;
    use GraphQL::Type::Object;
    use GraphQL::Type::Scalar qw/ $String /;

    my $schema = GraphQL::Schema->new(
      query => GraphQL::Type::Object->new(
        name => 'QueryRoot',
        fields => {
          helloWorld => {
            type => $String,
            resolve => sub { 'Hello, world!' },
          },
        },
      ),
    );
    graphql '/graphql' => $schema;

    dance;

# DESCRIPTION

The `graphql` keyword which is exported by this plugin allow you to
define a route handler implementing a GraphQL endpoint.

Parameters, after the route pattern:

- $schema

    A [GraphQL::Schema](https://metacpan.org/pod/GraphQL::Schema) object.

- $root\_value

    An optional root value, passed to top-level resolvers.

- $field\_resolver

    An optional field resolver, replacing the GraphQL default.

The route handler code will be compiled to behave like the following:

- Passes to the [GraphQL](https://metacpan.org/pod/GraphQL) execute, the given schema, `$root_value` and `$field_resolver`.
- The action built matches POST / GET requests.
- Returns GraphQL results in JSON form.

# CONFIGURATION

By default the plugin will not return GraphiQL, but this can be overridden
with plugin setting 'graphiql', to true.

Here is example to use GraphiQL:

    plugins:
      GraphQL:
        graphiql: true

# AUTHOR

Ed J

Based heavily on [Dancer2::Plugin::Ajax](https://metacpan.org/pod/Dancer2::Plugin::Ajax) by "Dancer Core Developers".

# COPYRIGHT AND LICENSE

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
