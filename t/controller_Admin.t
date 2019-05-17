use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Monoidea::WWW';
use Monoidea::WWW::Controller::Admin;

ok( request('/admin')->is_success, 'Request should succeed' );
done_testing();
