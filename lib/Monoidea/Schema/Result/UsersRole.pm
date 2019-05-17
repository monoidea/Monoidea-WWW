use utf8;
package Monoidea::Schema::Result::UsersRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::UsersRole

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

=head1 TABLE: C<USERS_ROLES>

=cut

__PACKAGE__->table("USERS_ROLES");

=head1 ACCESSORS

=head2 users

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 roles

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "users",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "roles",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</users>

=item * L</roles>

=back

=cut

__PACKAGE__->set_primary_key("users", "roles");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Monoidea::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Monoidea::Schema::Result::Role",
  { roles_id => "roles" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 user

Type: belongs_to

Related object: L<Monoidea::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Monoidea::Schema::Result::User",
  { users_id => "users" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-03-30 12:04:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zMR2dhTMhFBVXP9HtC/q2Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
