use utf8;
package Monoidea::Schema::Result::VideoFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::VideoFile

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

=head1 TABLE: C<VIDEO_FILE>

=cut

__PACKAGE__->table("VIDEO_FILE");

=head1 ACCESSORS

=head2 video_file_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 media_account

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 resource_id

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 filename

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 creation_time

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 duration

  data_type: 'time'
  is_nullable: 0

=head2 width

  data_type: 'float'
  default_value: 1080
  is_nullable: 1

=head2 height

  data_type: 'float'
  default_value: 1080
  is_nullable: 1

=head2 fps

  data_type: 'float'
  default_value: 25
  is_nullable: 1

=head2 bitrate

  data_type: 'integer'
  default_value: 1200000
  is_nullable: 1

=head2 available

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "video_file_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "media_account",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "resource_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "filename",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "creation_time",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "duration",
  { data_type => "time", is_nullable => 0 },
  "width",
  { data_type => "float", default_value => 1080, is_nullable => 1 },
  "height",
  { data_type => "float", default_value => 1080, is_nullable => 1 },
  "fps",
  { data_type => "float", default_value => 25, is_nullable => 1 },
  "bitrate",
  { data_type => "integer", default_value => 1200000, is_nullable => 1 },
  "available",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</video_file_id>

=back

=cut

__PACKAGE__->set_primary_key("video_file_id");

=head1 RELATIONS

=head2 aproc_queues

Type: has_many

Related object: L<Monoidea::Schema::Result::AprocQueue>

=cut

__PACKAGE__->has_many(
  "aproc_queues",
  "Monoidea::Schema::Result::AprocQueue",
  { "foreign.video_file" => "self.video_file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 media_account

Type: belongs_to

Related object: L<Monoidea::Schema::Result::MediaAccount>

=cut

__PACKAGE__->belongs_to(
  "media_account",
  "Monoidea::Schema::Result::MediaAccount",
  { media_account_id => "media_account" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 vproc_queues

Type: has_many

Related object: L<Monoidea::Schema::Result::VprocQueue>

=cut

__PACKAGE__->has_many(
  "vproc_queues",
  "Monoidea::Schema::Result::VprocQueue",
  { "foreign.video_file" => "self.video_file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-04-11 01:10:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XA9g6I53cUSYHrgnL2Ioow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
