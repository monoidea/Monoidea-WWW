package Monoidea::WWW::Controller::Config;
use Moose;
use namespace::autoclean;

use Config::Simple;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Monoidea::WWW::Controller::Config - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_config / )){
#TODO:JK: implement me
    }else{
	$c->detach("access_denied");
    }
}

sub access_denied :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'accessdenied.tt';
}

sub service_config :Local {
    my ( $self, $c ) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_config / )){
	# config profile
	my $simple_config = new Config::Simple($c->config->{service_config_file});
	my $profile_name;

	if($simple_config){
	    $profile_name = $simple_config->param("profile_name");
	}

	if(!$profile_name){
	    $profile_name = 'default';
	}

	# service config
	my $service_config_rs = $c->model('MONOSERVICE::ServiceConfig');

	my $service_config = $service_config_rs->find({ profile_name => $profile_name });

	# create response
	my $dom = XML::LibXML::Document->new('1.0', 'UTF-8');

	my $root_node = XML::LibXML::Element->new('monoidea-service');
	$dom->setDocumentElement($root_node);

	my $node;

	$node = XML::LibXML::Element->new('scheduled-upload');
	$node->setAttribute(value => $service_config->scheduled_upload);
	$root_node->appendChild($node);

	if($service_config->upload_schedule_time){
	    $node = XML::LibXML::Element->new('upload-schedule-time');
	    $node->setAttribute(value => $service_config->upload_schedule_time);
	    $root_node->appendChild($node);
	}

	$node = XML::LibXML::Element->new('delayed-upload');
	$node->setAttribute(value => $service_config->delayed_upload);
	$root_node->appendChild($node);

	if($service_config->upload_delay_time){
	    $node = XML::LibXML::Element->new('upload-delay-time');
	    $node->setAttribute(value => $service_config->upload_delay_time);
	    $root_node->appendChild($node);
	}

	$node = XML::LibXML::Element->new('mov-width');
	$node->setAttribute(value => $service_config->mov_width);
	$root_node->appendChild($node);

	$node = XML::LibXML::Element->new('mov-height');
	$node->setAttribute(value => $service_config->mov_height);
	$root_node->appendChild($node);

	$node = XML::LibXML::Element->new('mov-fps');
	$node->setAttribute(value => $service_config->mov_fps);
	$root_node->appendChild($node);

	$node = XML::LibXML::Element->new('mov-bitrate');
	$node->setAttribute(value => $service_config->mov_bitrate);
	$root_node->appendChild($node);

	$node = XML::LibXML::Element->new('snd-channels');
	$node->setAttribute(value => $service_config->snd_channels);
	$root_node->appendChild($node);

	$node = XML::LibXML::Element->new('snd-samplerate');
	$node->setAttribute(value => $service_config->snd_samplerate);
	$root_node->appendChild($node);

	$node = XML::LibXML::Element->new('snd-bitrate');
	$node->setAttribute(value => $service_config->snd_bitrate);
	$root_node->appendChild($node);

	# write response
	my $response_body = $dom->toString(1);

	$c->response->headers->content_type('text/xml');
	$c->response->headers->content_length(length $response_body);
	$c->response->headers->last_modified(time);

	$c->response->body($response_body);
    }else{
	$c->detach("access_denied");
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
