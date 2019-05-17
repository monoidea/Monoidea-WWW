use utf8;
package Monoidea::Schema::Result::Product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Monoidea::Schema::Result::Product

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

=head1 TABLE: C<PRODUCT>

=cut

__PACKAGE__->table("PRODUCT");

=head1 ACCESSORS

=head2 product_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 product_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 price

  data_type: 'decimal'
  is_nullable: 1
  size: [15,2]

=cut

__PACKAGE__->add_columns(
  "product_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "product_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "price",
  { data_type => "decimal", is_nullable => 1, size => [15, 2] },
);

=head1 PRIMARY KEY

=over 4

=item * L</product_id>

=back

=cut

__PACKAGE__->set_primary_key("product_id");

=head1 RELATIONS

=head2 purchases

Type: has_many

Related object: L<Monoidea::Schema::Result::Purchase>

=cut

__PACKAGE__->has_many(
  "purchases",
  "Monoidea::Schema::Result::Purchase",
  { "foreign.product" => "self.product_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-03-29 22:56:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AiOKAqSRff4XmaSRSLMjDQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
