use utf8;
package Monoidea::Schema::Result::Purchase;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::Purchase

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

=head1 TABLE: C<PURCHASE>

=cut

__PACKAGE__->table("PURCHASE");

=head1 ACCESSORS

=head2 purchase_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 position_id

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=head2 payment

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 billing_time

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "purchase_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "position_id",
  { data_type => "varchar", is_nullable => 0, size => 256 },
  "payment",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "billing_time",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</purchase_id>

=back

=cut

__PACKAGE__->set_primary_key("purchase_id");

=head1 RELATIONS

=head2 payment

Type: belongs_to

Related object: L<Monoidea::Schema::Result::Payment>

=cut

__PACKAGE__->belongs_to(
  "payment",
  "Monoidea::Schema::Result::Payment",
  { payment_id => "payment" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 product

Type: belongs_to

Related object: L<Monoidea::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Monoidea::Schema::Result::Product",
  { product_id => "product" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-04-03 17:40:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xIO28tFFEUvuUDtNSYIeLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
