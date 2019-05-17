package Monoidea::WWW::Controller::Cleaner;
use Moose;
use namespace::autoclean;
use DateTime::Format::Strptime;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Monoidea::WWW::Controller::Cleaner - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    if($c->user_exists() && $c->check_user_roles( qw / can_clean / )){
#TODO:JK: implement me
    }else{
	$c->detach("access_denied");
    }
}

sub access_denied :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'accessdenied.tt';
}

sub check_clean :Local {
    my ( $self, $c ) = @_;
    
    if($c->user_exists() && $c->check_user_roles( qw / can_clean / )){
	# config profile
	my $simple_config = new Config::Simple($c->config->{service_config_file});
	
	my $profile_name = $simple_config->param("profile_name");

	if(!$profile_name){
	    $profile_name = 'default';
	}

	# service config
	my $service_config_rs = $c->model('MONOSERVICE::ServiceConfig');

	my $service_config = $service_config_rs->find({ profile_name => $profile_name });

	my $strp = DateTime::Format::Strptime->new(
	    pattern => '%Y-%m-%d  %T',
	    time_zone => 'GMT-0',
	    );

	# check clean interval
	my $last_cleaned_dt = $strp->parse_datetime($service_config->last_cleaned);
	my $last_cleaned = $last_cleaned_dt->epoch;

	my $clean_interval_dt = $strp->parse_datetime($service_config->clean_interval);
	my $clean_interval = $clean_interval_dt->epoch;

	if($last_cleaned + $clean_interval > time){
	    my $timestamp_sec = time;

	    # update last cleaned
	    my ($current_time_sec, $current_time_min, $current_time_hr, $current_time_day, $current_time_month, $current_time_year, $current_time_wday, $current_time_yday, $current_time_isdst) = localtime($timestamp_sec);
	    $current_time_year += 1900;
	    $current_time_month += 1;

	    $service_config->update({ last_cleaned => sprintf('%04d-%02d-%02d %02d:%02d:%02d', $current_time_year, $current_time_month, $current_time_day, $current_time_hr, $current_time_min, $current_time_sec) });

	    # clean upload
	    my $upload_max_age_dt = $strp->parse_datetime($service_config->upload_max_age);
	    my $upload_max_age_timestamp_sec = $upload_max_age_dt->epoch;

	    my $upload_deprecated_timestamp_sec = $timestamp_sec - $upload_max_age_timestamp_sec;

	    my ($upload_deprecated_sec, $upload_deprecated_min, $upload_deprecated_hr, $upload_deprecated_day, $upload_deprecated_month, $upload_deprecated_year, $upload_deprecated_wday, $upload_deprecated_yday, $upload_deprecated_isdst) = localtime($upload_deprecated_timestamp_sec);
	    $upload_deprecated_year += 1900;
	    $upload_deprecated_month += 1;

	    my $upload_deprecated_time = sprintf('%04d-%02d-%02d %02d:%02d:%02d', $upload_deprecated_year, $upload_deprecated_month, $upload_deprecated_day, $upload_deprecated_hr, $upload_deprecated_min, $upload_deprecated_sec);

	    # clean cam
	    my $cam_upload_rs = $c->model('MONOSERVICE::CamUploadFile');

	    my $cam_upload = $cam_upload_rs->search({ creation_time => { '<' =>  $upload_deprecated_time} });

	    while(my $current = $cam_upload->next){
		unlink $current->filename;

		$current->delete;
	    }

	    # clean raw video
	    my $raw_video_rs = $c->model('MONOSERVICE::RawVideoFile');

	    my $raw_video = $raw_video_rs->search({ creation_time => { '<' =>  $upload_deprecated_time} });

	    while(my $current = $raw_video->next){
		unlink $current->filename;

		$current->delete;
	    }

	    # clean mic
	    my $mic_upload_rs = $c->model('MONOSERVICE::MicUploadFile');

	    my $mic_upload = $mic_upload_rs->search({ creation_time => { '<' =>  $upload_deprecated_time} });

	    while(my $current = $mic_upload->next){
		unlink $current->filename;

		$current->delete;
	    }

	    # clean raw audio
	    my $raw_audio_rs = $c->model('MONOSERVICE::RawAudioFile');

	    my $raw_audio = $raw_audio_rs->search({ creation_time => { '<' =>  $upload_deprecated_time} });

	    while(my $current = $raw_audio->next){
		unlink $current->filename;

		$current->delete;
	    }

	    # clean download
	    my $download_max_age_dt = $strp->parse_datetime($service_config->download_max_age);
	    my $download_max_age_timestamp_sec = $download_max_age_dt->epoch;

	    my $download_deprecated_timestamp_sec = $timestamp_sec - $download_max_age_timestamp_sec;

	    my ($download_deprecated_sec, $download_deprecated_min, $download_deprecated_hr, $download_deprecated_day, $download_deprecated_month, $download_deprecated_year, $download_deprecated_wday, $download_deprecated_yday, $download_deprecated_isdst) = localtime($download_deprecated_timestamp_sec);
	    $download_deprecated_year += 1900;
	    $download_deprecated_month += 1;

	    my $download_deprecated_time = sprintf('%04d-%02d-%02d %02d:%02d:%02d', $download_deprecated_year, $download_deprecated_month, $download_deprecated_day, $download_deprecated_hr, $download_deprecated_min, $download_deprecated_sec);

	    # clean video
	    my $video_rs = $c->model('MONOSERVICE::VideoFile');

	    my $video = $video_rs->search({ creation_time => { '<' =>  $download_deprecated_time} });

	    while(my $current = $video->next){
		unlink $current->filename;

		$current->delete;
	    }

	}
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
