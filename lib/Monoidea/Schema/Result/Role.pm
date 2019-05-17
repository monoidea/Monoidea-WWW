use utf8;
package Monoidea::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::Role

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

=head1 TABLE: C<ROLES>

=cut

__PACKAGE__->table("ROLES");

=head1 ACCESSORS

=head2 roles_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 role_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "roles_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "role_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</roles_id>

=back

=cut

__PACKAGE__->set_primary_key("roles_id");

=head1 RELATIONS

=head2 users_roles

Type: has_many

Related object: L<Monoidea::Schema::Result::UsersRole>

=cut

__PACKAGE__->has_many(
  "users_roles",
  "Monoidea::Schema::Result::UsersRole",
  { "foreign.roles" => "self.roles_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users

Type: many_to_many

Composing rels: L</users_roles> -> user

=cut

__PACKAGE__->many_to_many("users", "users_roles", "user");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-03-30 12:04:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kiCc4uu1P+5rOAizHHfVEw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
