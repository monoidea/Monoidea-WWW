use utf8;
package Monoidea::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::User

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

=head1 TABLE: C<USERS>

=cut

__PACKAGE__->table("USERS");

=head1 ACCESSORS

=head2 users_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 status

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 last_whisper

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "users_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "status",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "last_whisper",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</users_id>

=back

=cut

__PACKAGE__->set_primary_key("users_id");

=head1 RELATIONS

=head2 users_roles

Type: has_many

Related object: L<Monoidea::Schema::Result::UsersRole>

=cut

__PACKAGE__->has_many(
  "users_roles",
  "Monoidea::Schema::Result::UsersRole",
  { "foreign.users" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</users_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "users_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-03-30 12:04:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WVdy8ENJzPj9AhhCljBr8A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
