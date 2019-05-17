use utf8;
package Monoidea::Schema::Result::ScreenUploadFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::ScreenUploadFile

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

=head1 TABLE: C<SCREEN_UPLOAD_FILE>

=cut

__PACKAGE__->table("SCREEN_UPLOAD_FILE");

=head1 ACCESSORS

=head2 screen_upload_file_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

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
  "screen_upload_file_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
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

=item * L</screen_upload_file_id>

=back

=cut

__PACKAGE__->set_primary_key("screen_upload_file_id");

=head1 RELATIONS

=head2 vproc_queue_screen_upload_files

Type: has_many

Related object: L<Monoidea::Schema::Result::VprocQueueScreenUploadFile>

=cut

__PACKAGE__->has_many(
  "vproc_queue_screen_upload_files",
  "Monoidea::Schema::Result::VprocQueueScreenUploadFile",
  { "foreign.screen_upload_file" => "self.screen_upload_file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 vproc_queues

Type: many_to_many

Composing rels: L</vproc_queue_screen_upload_files> -> vproc_queue

=cut

__PACKAGE__->many_to_many(
  "vproc_queues",
  "vproc_queue_screen_upload_files",
  "vproc_queue",
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-04-11 01:10:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/awHKa2BjlwhSbn/DY42hw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
