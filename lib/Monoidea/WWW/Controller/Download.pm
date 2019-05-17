package Monoidea::WWW::Controller::Download;
use Moose;
use IO::File;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Monoidea::WWW::Controller::Download - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $session_id = $c->req->params->{'session_id'};
    my $token = $c->req->params->{'token'};

    my $session_store_rs = $c->model('MONOSERVICE::SessionStore');
    my $session_store = $session_store_rs->find({ session_id => { 'eq' => $session_id },
						  token => { 'eq' => $token },
						});

    if($session_store){
	my $video_file_rs = $c->model('MONOSERVICE::VideoFile');
	my $video_file = $video_file_rs->search({ media_account => { '=' => $session_store->media_account->media_account_id },
						});

	my @arr;

	while( my $v = $video_file->next){
	    push @arr, ( $v->video_file_id );
	}

	$c->stash(
	    session_id => $session_id,
	    token => $token,
	    current_view => 'Download',
	    video_file_id => \@arr,
	    );
    }else{
	$c->detach("access_denied");
    }
}

sub access_denied :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'accessdenied.tt';
}

sub media :Local {
    my ( $self, $c ) = @_;

    my $session_id = $c->req->params->{'session_id'};
    my $token = $c->req->params->{'token'};
    my $video_file_id = $c->req->params->{'video_file_id'};

    my $session_store_rs = $c->model('MONOSERVICE::SessionStore');
    my $session_store = $session_store_rs->find({session_id => $session_id},
						{toke => $token});

    if($session_store){
	my $media_account_rs = $c->model('MONOSERVICE::MediaAccount');
	my $media_account = $media_account_rs->find({media_account_id => $session_store->media_account});

	my $video_file_rs = $c->model('MONOSERVICE::VideoFile');
	my $video_file = $video_file_rs->find({media_account => $session_store->media_account,
					       video_file_id => $video_file_id});

	if($video_file && $video_file->available){
	    $c->response->headers->content_type('video/mp4');
	    $c->response->headers->content_length(-s $video_file->filename);
	    $c->response->headers->last_modified((stat($video_file->filename))[9]);

	    open(my $fh, '<:raw', $video_file->filename);
	    $c->response->body($fh);
	}
    }
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
