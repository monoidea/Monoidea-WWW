use utf8;
package Monoidea::Schema::Result::ServiceConfig;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::ServiceConfig

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

=head1 TABLE: C<SERVICE_CONFIG>

=cut

__PACKAGE__->table("SERVICE_CONFIG");

=head1 ACCESSORS

=head2 service_config_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 profile_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 upload_max_age

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 download_max_age

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 clean_interval

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 last_cleaned

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 scheduled_upload

  data_type: 'tinyint'
  is_nullable: 1

=head2 upload_schedule_time

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 delayed_upload

  data_type: 'tinyint'
  is_nullable: 1

=head2 upload_delay_time

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 mov_width

  data_type: 'float'
  default_value: 1080
  is_nullable: 1

=head2 mov_height

  data_type: 'float'
  default_value: 1080
  is_nullable: 1

=head2 mov_fps

  data_type: 'float'
  default_value: 25
  is_nullable: 1

=head2 mov_bitrate

  data_type: 'integer'
  default_value: 1200000
  is_nullable: 1

=head2 snd_channels

  data_type: 'integer'
  default_value: 2
  is_nullable: 1

=head2 snd_samplerate

  data_type: 'integer'
  default_value: 44100
  is_nullable: 1

=head2 snd_bitrate

  data_type: 'integer'
  default_value: 128000
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "service_config_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "profile_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "upload_max_age",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "download_max_age",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "clean_interval",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "last_cleaned",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "scheduled_upload",
  { data_type => "tinyint", is_nullable => 1 },
  "upload_schedule_time",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "delayed_upload",
  { data_type => "tinyint", is_nullable => 1 },
  "upload_delay_time",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "mov_width",
  { data_type => "float", default_value => 1080, is_nullable => 1 },
  "mov_height",
  { data_type => "float", default_value => 1080, is_nullable => 1 },
  "mov_fps",
  { data_type => "float", default_value => 25, is_nullable => 1 },
  "mov_bitrate",
  { data_type => "integer", default_value => 1200000, is_nullable => 1 },
  "snd_channels",
  { data_type => "integer", default_value => 2, is_nullable => 1 },
  "snd_samplerate",
  { data_type => "integer", default_value => 44100, is_nullable => 1 },
  "snd_bitrate",
  { data_type => "integer", default_value => 128000, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</service_config_id>

=back

=cut

__PACKAGE__->set_primary_key("service_config_id");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-04-11 01:10:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Koj60DbBt53gdvy5n+JKJg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
