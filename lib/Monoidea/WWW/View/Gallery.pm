package Monoidea::WWW::View::Gallery;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

Monoidea::WWW::View::Gallery - TT View for Monoidea::WWW

=head1 DESCRIPTION

TT View for Monoidea::WWW.

=head1 SEE ALSO

L<Monoidea::WWW>

=head1 AUTHOR

Joël Krähemann

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
