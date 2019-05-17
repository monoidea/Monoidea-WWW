# Monoservice - monoidea's monoservice
# Copyright (C) 2019 Joël Krähemann
#
# This file is part of Monoservice.
#
# Monoservice is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Monoservice is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Monoservice.  If not, see <http://www.gnu.org/licenses/>.

package Monoidea::Service::Media::Renderer;

use Moose;
use namespace::clean -except => 'meta';
use Monoidea::Schema;
use File::Path;
use List::Util;
use DateTime;
use DateTime::Format::Strptime;

use Monoidea::Service::Media::Resource;

has 'ffmpeg_path' => (is => 'rw', isa => 'Str', required => 1);
has 'destination_filename' => (is => 'rw', isa => 'Str', required => 1);
has 'start_timestamp_sec' => (is => 'rw', isa => 'Num', required => 1);
has 'end_timestamp_sec' => (is => 'rw', isa => 'Num', required => 1);
has 'audio_source' => (is => 'rw', isa => 'ArrayRef[Monoidea::Service::Media::Resource]', default => sub { [] });
has 'video_source' => (is => 'rw', isa => 'ArrayRef[Monoidea::Service::Media::Resource]', default => sub { [] });

sub process_source {
    my ( $self, $tmp_dir ) = @_;
    
    my $destination_dir = $tmp_dir . '/' . time;

    my $tmp = mkpath($destination_dir);

    my $concat_filename = $destination_dir . '/concat.txt';
    open(my $concat_fh, ">>", $concat_filename);

    # trim
    my @video_arr = @{$self->video_source()};

    printf "**** video count " . scalar(@video_arr) . "\n";

    for(my $i = 0; $i < @video_arr; $i++){
	my $start_sec = 0;
	my $duration_sec = $video_arr[$i]->duration_sec;

 	if($video_arr[$i]->timestamp_sec < $self->start_timestamp_sec){
	    $start_sec = $self->start_timestamp_sec - $video_arr[$i]->timestamp_sec;
	}

	if($video_arr[$i]->timestamp_sec + $video_arr[$i]->duration_sec > $self->end_timestamp_sec){
	    $duration_sec = $self->end_timestamp_sec - $video_arr[$i]->timestamp_sec;
	}

	my $trim_filename = $destination_dir . '/trim-' . sprintf('%03d', $i) . '.mp4';
	printf $concat_fh "file '" . $trim_filename . "'\n";

	my @trim_args;

	if($start_sec == 0 && $duration_sec == 60){
	    @trim_args = ($self->ffmpeg_path, '-r', 25, '-i', @{$self->video_source()}[$i]->filename, '-vcodec', 'copy', $trim_filename);
	}elsif($start_sec == 0){
	    @trim_args = ($self->ffmpeg_path, '-r', 25, '-i', @{$self->video_source()}[$i]->filename, '-t', $duration_sec, '-vcodec', 'copy', $trim_filename);
	}else{
	    @trim_args = ($self->ffmpeg_path, '-r', 25, '-ss', $start_sec, '-i', @{$self->video_source()}[$i]->filename, '-t', $duration_sec, '-vcodec', 'copy', $trim_filename);
	}

	system(@trim_args);
    }

    my $video_filename = $destination_dir . '/video.mp4';
    my @concat_args = ($self->ffmpeg_path, '-f', 'concat', '-safe' , '0', , '-r', 25, '-i', $concat_filename, '-vcodec', 'copy', $video_filename);
    
    system(@concat_args);

    my @audio_args = ($self->ffmpeg_path, '-r', 25, '-i', $video_filename, '-i', @{$self->audio_source}[0]->filename, '-c:v', 'copy', '-c:a', 'libfdk_aac', '-b:a', '128k', $self->destination_filename);

    system(@audio_args);
}

sub find_audio_source {
    my ( $self, $raw_audio_rs ) = @_;

    my $raw_audio;

    # start time
    my ($start_sec, $start_min, $start_hr, $start_day, $start_month, $start_year, $start_wday, $start_yday, $start_isdst) = localtime($self->start_timestamp_sec);
    $start_year += 1900;
    $start_month += 1;

    my $start_time = sprintf('%04d-%02d-%02d %02d:%02d:%02d', $start_year, $start_month, $start_day, $start_hr, $start_min, $start_sec);

    while(!$raw_audio) {
	$raw_audio = $raw_audio_rs->find({ creation_time => $start_time,
					   available => 1,
					 });

	printf "**** check audio completed\n";

	if($raw_audio){
	    my @audio_arr = @{$self->audio_source()};

	    my $date_parser = DateTime::Format::Strptime::->new(
		pattern => '%Y-%m-%dT%T',
		time_zone => 'GMT-0',
		);
	    my $dt;

	    $dt = $date_parser->parse_datetime($raw_audio->creation_time);
	    my $creation_time = $dt->epoch();

	    $dt = $date_parser->parse_datetime('1970-01-01T' . $raw_audio->duration);
	    my $duration = $dt->epoch();

	    my $media_resource = Monoidea::Service::Media::Resource->new( filename => $raw_audio->filename,
									  content_type => 'audio/wav',
									  creation_time => $creation_time,
									  duration => $duration);
	    push @{$self->audio_source()}, ( $media_resource );
	}else{
	    sleep(10);
	}
    }
}

sub find_video_source {
    my ( $self, $cam_upload_rs ) = @_;

    my $completed = 0;

    # start time
    my ($start_sec, $start_min, $start_hr, $start_day, $start_month, $start_year, $start_wday, $start_yday, $start_isdst) = localtime($self->start_timestamp_sec);
    $start_year += 1900;
    $start_month += 1;

    my $start_time = sprintf('%04d-%02d-%02d %02d:%02d:%02d', $start_year, $start_month, $start_day, $start_hr, $start_min, $start_sec);

    # end time
    my ($end_sec, $end_min, $end_hr, $end_day, $end_month, $end_year, $end_wday, $end_yday, $end_isdst) = localtime($self->end_timestamp_sec);
    $end_year += 1900;
    $end_month += 1;

    my $end_time = sprintf('%04d-%02d-%02d %02d:%02d:%02d', $end_year, $end_month, $end_day, $end_hr, $end_min, $end_sec);

    while(!$completed) {
	my $cam_upload = $cam_upload_rs->search({ creation_time => { '>=' =>  $start_time},
						  creation_time => { '<' => $end_time },
						  available => 1,
						});
	
	while(my $current = $cam_upload->next){
	    my @video_arr = @{$self->video_source()};

	    my $date_parser = DateTime::Format::Strptime->new(
		pattern => '%Y-%m-%dT%T',
		time_zone => 'GMT-0',
		);
	    my $dt;

	    my $creation_time = 0;
	    my $duration = 0;

	    if(!(List::Util::any { $_->filename() eq $current->filename } @video_arr)){
		$dt = $date_parser->parse_datetime($current->creation_time);
		$creation_time = $dt->epoch;

		$dt = $date_parser->parse_datetime('1970-01-01T' . $current->duration);
		$duration = $dt->epoch;

		printf "**** push " . $current->filename . "\n";

		my $media_resource = Monoidea::Service::Media::Resource->new( filename => $current->filename,
									      content_type => 'video/mp4',
									      timestamp_sec => $creation_time,
									      duration_sec => $duration);

		push @{$self->video_source()}, ( $media_resource );
	    }

	    $dt = $date_parser->parse_datetime('1970-01-01T' . $current->duration);
	    $duration = $dt->epoch;

	    printf "**** check video completed\n";

	    if($creation_time + $duration >= $self->end_timestamp_sec()){
		$completed = 1;
	    }
	}

	if(!$completed){
	    sleep(10);
	}

    }
}

__PACKAGE__->meta->make_immutable;

1;
