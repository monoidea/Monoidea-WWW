package Monoidea::WWW::Controller::People;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Monoidea::WWW::Controller::People - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub login :Local :Args(0) {
    my ( $self, $c ) = @_;

    if(exists($c->req->params->{'username'})){
	if($c->authenticate({
	    username => $c->req->params->{'username'},
	    password => $c->req->params->{'password'}
			    })){
	    $c->stash->{'message'} = "You are now logged in.";

	    $c->response->redirect(
		$c->uri_for($c->controller('Admin')->action_for('start') )
		);
	    $c->detach();

	    return;
	}else{
	    $c->stash->{'message'} = "Invalid login.";
	}
    }
}

sub logout :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->stash->{'template'} = 'people/logout.tt';
    $c->logout();

    $c->stash->{'message'} = "You have been logged out.";
}

=encoding utf8

=head1 AUTHOR

Joël Krähemann

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
