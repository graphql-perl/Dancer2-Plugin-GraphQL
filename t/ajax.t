use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw<GET POST>;

{
  package GraphQLApp;
  use Dancer2;
  use Dancer2::Plugin::GraphQL;
  set plugins => { 'GraphQL' => { graphiql => 1 } };
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
}

my $test = Plack::Test->create( GraphQLApp->to_app );

subtest 'GraphQL with POST' => sub {
  my $res = $test->request(
    POST '/graphql',
      Content_Type => 'application/json',
      Content => '{"query":"{helloWorld}"}',
  );
  my $json = JSON::MaybeXS->new->allow_nonref;
  is_deeply eval { $json->decode( $res->decoded_content ) },
    { 'data' => { 'helloWorld' => 'Hello, world!' } },
    'Content as expected';
};

subtest 'GraphiQL' => sub {
  my $res = $test->request(
    GET '/graphql',
      Accept => 'text/html',
  );
  like $res->decoded_content, qr/React.createElement\(GraphiQL/, 'Content as expected';
};

done_testing;
