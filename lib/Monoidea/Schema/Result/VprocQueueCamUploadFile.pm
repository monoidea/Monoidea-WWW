use utf8;
package Monoidea::Schema::Result::VprocQueueCamUploadFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::VprocQueueCamUploadFile

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

=head1 TABLE: C<VPROC_QUEUE_CAM_UPLOAD_FILE>

=cut

__PACKAGE__->table("VPROC_QUEUE_CAM_UPLOAD_FILE");

=head1 ACCESSORS

=head2 vproc_queue

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 cam_upload_file

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "vproc_queue",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "cam_upload_file",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</vproc_queue>

=item * L</cam_upload_file>

=back

=cut

__PACKAGE__->set_primary_key("vproc_queue", "cam_upload_file");

=head1 RELATIONS

=head2 cam_upload_file

Type: belongs_to

Related object: L<Monoidea::Schema::Result::CamUploadFile>

=cut

__PACKAGE__->belongs_to(
  "cam_upload_file",
  "Monoidea::Schema::Result::CamUploadFile",
  { cam_upload_file_id => "cam_upload_file" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 vproc_queue

Type: belongs_to

Related object: L<Monoidea::Schema::Result::VprocQueue>

=cut

__PACKAGE__->belongs_to(
  "vproc_queue",
  "Monoidea::Schema::Result::VprocQueue",
  { vproc_queue_id => "vproc_queue" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-03-29 22:56:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7XKESHDVLGr/sz60A0NBXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
