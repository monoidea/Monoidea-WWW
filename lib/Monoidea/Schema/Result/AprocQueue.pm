use utf8;
package Monoidea::Schema::Result::AprocQueue;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::AprocQueue

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

=head1 TABLE: C<APROC_QUEUE>

=cut

__PACKAGE__->table("APROC_QUEUE");

=head1 ACCESSORS

=head2 aproc_queue_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 video_file

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 raw_audio_file

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 title_strip_audio_file

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 end_credits_audio_file

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 started

  data_type: 'tinyint'
  is_nullable: 1

=head2 completed

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "aproc_queue_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "video_file",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "raw_audio_file",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "title_strip_audio_file",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "end_credits_audio_file",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "started",
  { data_type => "tinyint", is_nullable => 1 },
  "completed",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</aproc_queue_id>

=back

=cut

__PACKAGE__->set_primary_key("aproc_queue_id");

=head1 RELATIONS

=head2 aproc_queue_mic_upload_files

Type: has_many

Related object: L<Monoidea::Schema::Result::AprocQueueMicUploadFile>

=cut

__PACKAGE__->has_many(
  "aproc_queue_mic_upload_files",
  "Monoidea::Schema::Result::AprocQueueMicUploadFile",
  { "foreign.aproc_queue" => "self.aproc_queue_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 aproc_queue_soundcard_upload_files

Type: has_many

Related object: L<Monoidea::Schema::Result::AprocQueueSoundcardUploadFile>

=cut

__PACKAGE__->has_many(
  "aproc_queue_soundcard_upload_files",
  "Monoidea::Schema::Result::AprocQueueSoundcardUploadFile",
  { "foreign.aproc_queue" => "self.aproc_queue_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 end_credits_audio_file

Type: belongs_to

Related object: L<Monoidea::Schema::Result::EndCreditsAudioFile>

=cut

__PACKAGE__->belongs_to(
  "end_credits_audio_file",
  "Monoidea::Schema::Result::EndCreditsAudioFile",
  { end_credits_audio_file_id => "end_credits_audio_file" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 raw_audio_file

Type: belongs_to

Related object: L<Monoidea::Schema::Result::RawAudioFile>

=cut

__PACKAGE__->belongs_to(
  "raw_audio_file",
  "Monoidea::Schema::Result::RawAudioFile",
  { raw_audio_file_id => "raw_audio_file" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 title_strip_audio_file

Type: belongs_to

Related object: L<Monoidea::Schema::Result::TitleStripAudioFile>

=cut

__PACKAGE__->belongs_to(
  "title_strip_audio_file",
  "Monoidea::Schema::Result::TitleStripAudioFile",
  { title_strip_audio_file_id => "title_strip_audio_file" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 video_file

Type: belongs_to

Related object: L<Monoidea::Schema::Result::VideoFile>

=cut

__PACKAGE__->belongs_to(
  "video_file",
  "Monoidea::Schema::Result::VideoFile",
  { video_file_id => "video_file" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 mic_upload_files

Type: many_to_many

Composing rels: L</aproc_queue_mic_upload_files> -> mic_upload_file

=cut

__PACKAGE__->many_to_many(
  "mic_upload_files",
  "aproc_queue_mic_upload_files",
  "mic_upload_file",
);

=head2 soundcard_upload_files

Type: many_to_many

Composing rels: L</aproc_queue_soundcard_upload_files> -> soundcard_upload_file

=cut

__PACKAGE__->many_to_many(
  "soundcard_upload_files",
  "aproc_queue_soundcard_upload_files",
  "soundcard_upload_file",
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-03-29 22:56:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:27mb0STOBeQhijmqjas6TQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
