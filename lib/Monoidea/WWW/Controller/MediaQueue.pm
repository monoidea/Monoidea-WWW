package Monoidea::WWW::Controller::MediaQueue;
use Moose;
use namespace::autoclean;
use File::Path;
use Monoidea::Schema;
use Monoidea::Service::Media::Renderer;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Monoidea::WWW::Controller::MediaQueue - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_export / )){
#TODO:JK: implement me
    }else{
	$c->detach("access_denied");
    }
}

sub access_denied :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'accessdenied.tt';
}

sub export :Local {
    my ( $self, $c ) = @_;
    
    if($c->user_exists() && $c->check_user_roles( qw / can_export / )){
	my $media_account_id = $c->req->params->{'media_account_id'};
	my $creation_time = $c->req->params->{'creation_time'};
	my $duration = $c->req->params->{'duration'};

	my $video_file_rs = $c->model('MONOSERVICE::VideoFile');

	my ($creation_time_sec, $creation_time_min, $creation_time_hr, $creation_time_day, $creation_time_month, $creation_time_year, $creation_time_wday, $creation_time_yday, $creation_time_isdst) = localtime($creation_time);
	$creation_time_year += 1900;
	$creation_time_month += 1900;

	my ($duration_sec, $duration_min, $duration_hr, $duration_day, $duration_month, $duration_year, $duration_wday, $duration_yday, $duration_isdst) = localtime($duration);

	File::Path->make_path($c->config->{download_dir} . '/media/video/' . $creation_time . '/');

	my $resource_guid = Data::GUID->new;

	my $video_file = $video_file_rs->create({ filename => $c->config->{download_dir} . '/media/video/' . $creation_time . '/monothek_download.mp4',
						  media_account => $media_account_id,
						  resource_id => $resource_guid->as_string,
						  creation_time => sprintf('%04d-%02d-%02d %02d:%02d:%02d', $creation_time_year, $creation_time_month, $creation_time_day, $creation_time_hr, $creation_time_min, $creation_time_sec),
						  duration => sprintf('%02d:%02d:%02d.00000', $duration_hr, $duration_min, $duration_sec),
						});

	my $media_renderer = Monoidea::Service::Media::Renderer->new(ffmpeg_path => $c->config->{ffmpeg_path},
								     destination_filename => $video_file->filename,
								     start_timestamp_sec => $creation_time,
								     end_timestamp_sec => ($creation_time + $duration));


	my $raw_audio_rs = $c->model('MONOSERVICE::RawAudioFile');
	my $cam_upload_rs = $c->model('MONOSERVICE::CamUploadFile');

	$media_renderer->find_audio_source($raw_audio_rs);

	$media_renderer->find_video_source($cam_upload_rs);

	$media_renderer->process_source($c->config->{tmp_dir});

	$video_file->update({ available => 1 });

	$c->response->body('success');
	$c->response->status(200);
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
