use utf8;
package Monoidea::Schema::Result::SessionStore;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::SessionStore

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

=head1 TABLE: C<SESSION_STORE>

=cut

__PACKAGE__->table("SESSION_STORE");

=head1 ACCESSORS

=head2 session_store_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 media_account

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 last_seen

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 active

  data_type: 'tinyint'
  is_nullable: 1

=head2 session_id

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 token

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=cut

__PACKAGE__->add_columns(
  "session_store_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "media_account",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "last_seen",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "active",
  { data_type => "tinyint", is_nullable => 1 },
  "session_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "token",
  { data_type => "varchar", is_nullable => 0, size => 36 },
);

=head1 PRIMARY KEY

=over 4

=item * L</session_store_id>

=back

=cut

__PACKAGE__->set_primary_key("session_store_id");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-04-01 07:33:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nU3b/hm3MGuBpA8fU8/Sqg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
