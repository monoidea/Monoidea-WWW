#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Monoidea-WWW';
all_from 'lib/Monoidea/WWW.pm';

requires 'Test::More';
requires 'YAML';
requires 'Data::Dumper';
requires 'Test::Builder::Tester';
requires 'Test::Pod';
requires 'Module::Starter';
requires 'Module::Install';
requires 'DBD::mysql';
requires 'Moose';
requires 'DBI';
requires 'Catalyst';
requires 'SQL::Translator';
requires 'JSON::Any';
requires 'MooseX::Types::JSON';
requires 'MooseX::NonMoose';
requries 'Class::DBI';
requries 'DBIx::Class';
requires 'Catalyst::Helper::Model::DBIC::Schema';
requires 'Catalyst::Model::DBIC::Schema';
requries 'DBIx::Class::TimeStamp';
requires 'Email::Valid';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Runtime' => '5.90124';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::View::TT';
requires 'Catalyst::View::JSON';
requires 'Catalyst::Plugin::Unicode';
requires 'ExtUtils::Command::MM';
requires 'XML::LibXML';
requires 'Cairo';
requires 'Text::QRCode';
requires 'Data::GUID';
requires 'Config::Simple';

requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
