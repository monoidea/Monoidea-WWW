use utf8;
package Monoidea::Schema::Result::MediaAccount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::MediaAccount

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

=head1 TABLE: C<MEDIA_ACCOUNT>

=cut

__PACKAGE__->table("MEDIA_ACCOUNT");

=head1 ACCESSORS

=head2 media_account_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 billing_address

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "media_account_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "billing_address",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</media_account_id>

=back

=cut

__PACKAGE__->set_primary_key("media_account_id");

=head1 RELATIONS

=head2 billing_address

Type: belongs_to

Related object: L<Monoidea::Schema::Result::BillingAddress>

=cut

__PACKAGE__->belongs_to(
  "billing_address",
  "Monoidea::Schema::Result::BillingAddress",
  { billing_address_id => "billing_address" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 session_stores

Type: has_many

Related object: L<Monoidea::Schema::Result::SessionStore>

=cut

__PACKAGE__->has_many(
  "session_stores",
  "Monoidea::Schema::Result::SessionStore",
  { "foreign.media_account" => "self.media_account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 video_files

Type: has_many

Related object: L<Monoidea::Schema::Result::VideoFile>

=cut

__PACKAGE__->has_many(
  "video_files",
  "Monoidea::Schema::Result::VideoFile",
  { "foreign.media_account" => "self.media_account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-03-29 22:56:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p8W8Pr6sFYG3gp0pifp4Dg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
