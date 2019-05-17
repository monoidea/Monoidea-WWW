package Monoidea::WWW::Controller::Monoservice::Download;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Monoidea::WWW::Controller::Monoservice::Download - Catalyst Controller

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

    my $command = $c->req->params->{'command'};

    my $session_store_rs = $c->model('MONOSERVICE::SessionStore');
    my $session_store = $session_store_rs->find({ session_id => { '=' => $session_id },
						  token => { '=' => $token },
						});

    if($session_store){
	if($command &&
	   $command eq 'list-record'){
	    # create response
	    my $dom = XML::LibXML::Document->new('1.0', 'UTF-8');

	    my $root_node = XML::LibXML::Element->new('monoidea-download');
	    $dom->setDocumentElement($root_node);

	    my $video_file_rs = $c->model('MONOSERVICE::VideoFile');
	    my $video_file = $video_file_rs->search({ media_account => $session_store->media_account->media_account_id,
						    });

	    while( my $v = $video_file->next){
		my $media_node;
		my $node;

		$media_node = XML::LibXML::Element->new('media');
		$root_node->appendChild($media_node);

		$node = XML::LibXML::Element->new('session-id');
		$node->appendText($session_id);
		$media_node->appendChild($node);

		$node = XML::LibXML::Element->new('token');
		$node->appendText($token);
		$media_node->appendChild($node);

		$node = XML::LibXML::Element->new('video-file-id');
		$node->appendText($v->video_file_id);
		$media_node->appendChild($node);
	    }

	    # write response
	    my $response_body = $dom->toString(1);

	    $c->response->headers->content_type('application/xml');
	    $c->response->headers->content_length(length $response_body);
	    $c->response->headers->last_modified(time);

	    $c->response->body($response_body);
	}else{
	    # config profile
	    my $simple_config = new Config::Simple($c->config->{service_config_file});
	    
	    my $www_video_width = $simple_config->param("www_video_width");

	    if(!$www_video_width){
		$www_video_width = 720;
	    }

	    my $www_video_height = $simple_config->param("www_video_height");

	    if(!$www_video_height){
		$www_video_height = 720;
	    }

	    $c->stash(
		session_id => $session_id,
		token => $token,
		videoWidth => $www_video_width,
		videoHeight => $www_video_height,
		template => 'monoservice/download.tt',
		);
	}
    }else{
	$c->detach("access_denied");
    }
}

sub access_denied :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'accessdenied.tt';
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
