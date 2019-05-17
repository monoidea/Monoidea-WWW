use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Monoidea::WWW';
use Monoidea::WWW::Controller::Config;

ok( request('/config')->is_success, 'Request should succeed' );
done_testing();
