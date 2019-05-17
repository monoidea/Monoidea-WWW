use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Monoidea::WWW';
use Monoidea::WWW::Controller::Cleaner;

ok( request('/cleaner')->is_success, 'Request should succeed' );
done_testing();
