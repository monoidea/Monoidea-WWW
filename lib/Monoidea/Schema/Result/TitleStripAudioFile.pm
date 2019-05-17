use utf8;
package Monoidea::Schema::Result::TitleStripAudioFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::TitleStripAudioFile

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<TITLE_STRIP_AUDIO_FILE>

=cut

__PACKAGE__->table("TITLE_STRIP_AUDIO_FILE");

=head1 ACCESSORS

=head2 title_strip_audio_file_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 filename

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 duration

  data_type: 'time'
  is_nullable: 0

=head2 channels

  data_type: 'integer'
  default_value: 2
  is_nullable: 1

=head2 samplerate

  data_type: 'integer'
  default_value: 44100
  is_nullable: 1

=head2 bitrate

  data_type: 'integer'
  default_value: 128000
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "title_strip_audio_file_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "filename",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "duration",
  { data_type => "time", is_nullable => 0 },
  "channels",
  { data_type => "integer", default_value => 2, is_nullable => 1 },
  "samplerate",
  { data_type => "integer", default_value => 44100, is_nullable => 1 },
  "bitrate",
  { data_type => "integer", default_value => 128000, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</title_strip_audio_file_id>

=back

=cut

__PACKAGE__->set_primary_key("title_strip_audio_file_id");

=head1 RELATIONS

=head2 aproc_queues

Type: has_many

Related object: L<Monoidea::Schema::Result::AprocQueue>

=cut

__PACKAGE__->has_many(
  "aproc_queues",
  "Monoidea::Schema::Result::AprocQueue",
  {
    "foreign.title_strip_audio_file" => "self.title_strip_audio_file_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-04-08 05:41:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LzID+qfu6miKpMCpCqIHpA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
