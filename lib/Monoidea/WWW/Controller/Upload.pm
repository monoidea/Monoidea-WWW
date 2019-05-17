package Monoidea::WWW::Controller::Upload;
use Moose;
use namespace::autoclean;
use Data::Integer;
use File::Path;
use File::Copy;
use Monoidea::Schema;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Monoidea::WWW::Controller::Upload - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_upload / )){
#TODO:JK: implement me
    }else{
	$c->detach("access_denied");
    }
}

sub access_denied :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'accessdenied.tt';
}

sub put_cam :Local {
    my ($self, $c) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_upload / )){
	my $filename = $c->req->params->{'filename'};
	my $creation_time = $c->req->params->{'creation_time'};
	my $duration = $c->req->params->{'duration'};
	my $media_file = $c->req->upload('media_file');

	my $cam_upload_rs = $c->model('MONOSERVICE::CamUploadFile');

	my ($creation_time_sec, $creation_time_min, $creation_time_hr, $creation_time_day, $creation_time_month, $creation_time_year, $creation_time_wday, $creation_time_yday, $creation_time_isdst) = localtime($creation_time);
	$creation_time_year += 1900;
	$creation_time_month += 1;

	my ($duration_sec, $duration_min, $duration_hr, $duration_day, $duration_month, $duration_year, $duration_wday, $duration_yday, $duration_isdst) = localtime($duration);

	File::Path->make_path($c->config->{upload_dir} . '/media/cam/' . $creation_time_yday . '/' . $creation_time_hr . '/');

	my $new_cam_upload = $cam_upload_rs->create({ filename => $c->config->{upload_dir} . '/media/cam/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename,
						      creation_time => sprintf('%04d-%02d-%02d %02d:%02d:%02d', $creation_time_year, $creation_time_month, $creation_time_day, $creation_time_hr, $creation_time_min, $creation_time_sec),
						      duration => sprintf('%02d:%02d:%02d.00000', $duration_hr, $duration_min, $duration_sec),
						    });
	

	copy($media_file->fh, $c->config->{upload_dir} . '/media/cam/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename);

	$new_cam_upload->update({ available => 1 });

	$c->response->body('success');
	$c->response->status(200);
    }else{
	$c->detach("access_denied");
    }
}

sub put_raw_video :Local {
    my ($self, $c) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_upload / )){
	my $filename = $c->req->params->{'filename'};
	my $creation_time = $c->req->params->{'creation_time'};
	my $duration = $c->req->params->{'duration'};
	my $media_file = $c->req->upload('media_file');

	my $raw_video_rs = $c->model('MONOSERVICE::RawVideoFile');

	my ($creation_time_sec, $creation_time_min, $creation_time_hr, $creation_time_day, $creation_time_month, $creation_time_year, $creation_time_wday, $creation_time_yday, $creation_time_isdst) = localtime($creation_time);
	$creation_time_year += 1900;
	$creation_time_month += 1;

	my ($duration_sec, $duration_min, $duration_hr, $duration_day, $duration_month, $duration_year, $duration_wday, $duration_yday, $duration_isdst) = localtime($duration);

	File::Path->make_path($c->config->{upload_dir} . '/media/raw-video/' . $creation_time_yday . '/' . $creation_time_hr . '/');

	my $new_raw_video = $raw_video_rs->create({ filename => $c->config->{upload_dir} . '/media/raw-video/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename,
						    creation_time => sprintf('%04d-%02d-%02d %02d:%02d:%02d', $creation_time_year, $creation_time_month, $creation_time_day, $creation_time_hr, $creation_time_min, $creation_time_sec),
						    duration => sprintf('%02d:%02d:%02d.00000', $duration_hr, $duration_min, $duration_sec),
						  });
	

	copy($media_file->fh, $c->config->{upload_dir} . '/media/raw-video/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename);

	$new_raw_video->update({ available => 1 });

	$c->response->body('success');
	$c->response->status(200);
    }else{
	$c->detach("access_denied");
    }
}

sub put_mic :Local {
    my ($self, $c) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_upload / )){
	my $filename = $c->req->params->{'filename'};
	my $creation_time = $c->req->params->{'creation_time'};
	my $duration = $c->req->params->{'duration'};
	my $media_file = $c->req->upload('media_file');

	my $mic_upload_rs = $c->model('MONOSERVICE::MicUploadFile');

	my ($creation_time_sec, $creation_time_min, $creation_time_hr, $creation_time_day, $creation_time_month, $creation_time_year, $creation_time_wday, $creation_time_yday, $creation_time_isdst) = localtime($creation_time);
	$creation_time_year += 1900;
	$creation_time_month += 1;

	my ($duration_sec, $duration_min, $duration_hr, $duration_day, $duration_month, $duration_year, $duration_wday, $duration_yday, $duration_isdst) = localtime($duration);

	File::Path->make_path($c->config->{upload_dir} . '/media/mic/' . $creation_time_yday . '/' . $creation_time_hr . '/');

	my $new_mic_upload = $mic_upload_rs->create({ filename => $c->config->{upload_dir} . '/media/mic/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename,
						      creation_time => sprintf('%04d-%02d-%02d %02d:%02d:%02d', $creation_time_year, $creation_time_month, $creation_time_day, $creation_time_hr, $creation_time_min, $creation_time_sec),
						      duration => sprintf('%02d:%02d:%02d.00000', $duration_hr, $duration_min, $duration_sec),
						    });
	

	copy($media_file->fh, $c->config->{upload_dir} . '/media/mic/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename);

	$new_mic_upload->update({ available => 1 });

	$c->response->body('success');
	$c->response->status(200);
    }else{
	$c->detach("access_denied");
    }
}

sub put_raw_audio :Local {
    my ($self, $c) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_upload / )){
	my $filename = $c->req->params->{'filename'};
	my $creation_time = $c->req->params->{'creation_time'};
	my $duration = $c->req->params->{'duration'};
	my $media_file = $c->req->upload('media_file');

	my $raw_audio_rs = $c->model('MONOSERVICE::RawAudioFile');

	my ($creation_time_sec, $creation_time_min, $creation_time_hr, $creation_time_day, $creation_time_month, $creation_time_year, $creation_time_wday, $creation_time_yday, $creation_time_isdst) = localtime($creation_time);
	$creation_time_year += 1900;
	$creation_time_month += 1;

	my ($duration_sec, $duration_min, $duration_hr, $duration_day, $duration_month, $duration_year, $duration_wday, $duration_yday, $duration_isdst) = localtime($duration);

	File::Path->make_path($c->config->{upload_dir} . '/media/raw-audio/' . $creation_time_yday . '/' . $creation_time_hr . '/');

	my $new_raw_audio = $raw_audio_rs->create({ filename => $c->config->{upload_dir} . '/media/raw-audio/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename,
						    creation_time => sprintf('%04d-%02d-%02d %02d:%02d:%02d', $creation_time_year, $creation_time_month, $creation_time_day, $creation_time_hr, $creation_time_min, $creation_time_sec),
						    duration => sprintf('%02d:%02d:%02d.00000', $duration_hr, $duration_min, $duration_sec),
						  });
	

	copy($media_file->fh, $c->config->{upload_dir} . '/media/raw-audio/' . $creation_time_yday . '/' .  $creation_time_hr . '/' . $filename);

	$new_raw_audio->update({ available => 1 });

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
