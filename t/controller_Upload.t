use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Monoidea::WWW';
use Monoidea::WWW::Controller::Upload;

ok( request('/upload')->is_success, 'Request should succeed' );
done_testing();
