use strict;
use warnings;

use Monoidea::WWW;

my $app = Monoidea::WWW->apply_default_middlewares(Monoidea::WWW->psgi_app);
$app;

