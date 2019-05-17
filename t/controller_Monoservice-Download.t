use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Monoidea::WWW';
use Monoidea::WWW::Controller::Monoservice::Download;

ok( request('/monoservice/download')->is_success, 'Request should succeed' );
done_testing();
