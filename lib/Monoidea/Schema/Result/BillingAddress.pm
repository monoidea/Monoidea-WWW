use utf8;
package Monoidea::Schema::Result::BillingAddress;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::BillingAddress

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

=head1 TABLE: C<BILLING_ADDRESS>

=cut

__PACKAGE__->table("BILLING_ADDRESS");

=head1 ACCESSORS

=head2 billing_address_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 firstname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 surname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 phone

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 street

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 zip

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "billing_address_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "firstname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "surname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "phone",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "street",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "zip",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</billing_address_id>

=back

=cut

__PACKAGE__->set_primary_key("billing_address_id");

=head1 RELATIONS

=head2 media_accounts

Type: has_many

Related object: L<Monoidea::Schema::Result::MediaAccount>

=cut

__PACKAGE__->has_many(
  "media_accounts",
  "Monoidea::Schema::Result::MediaAccount",
  { "foreign.billing_address" => "self.billing_address_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 payments

Type: has_many

Related object: L<Monoidea::Schema::Result::Payment>

=cut

__PACKAGE__->has_many(
  "payments",
  "Monoidea::Schema::Result::Payment",
  { "foreign.billing_address" => "self.billing_address_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-04-03 17:40:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V9PymJJPBLSglJKjxtmSwQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
