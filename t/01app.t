#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 9;

BEGIN { use_ok 'Catalyst::Test', 'Monoidea::WWW' }
use HTTP::Headers;
use HTTP::Request::Common;

# GET request
my $request = GET('http://localhost');
my $response = request($request);

ok( $response = request($request), 'Basic request to start page');
ok( $response->is_success, 'Start page request successful 2xx' );

is( $response->content_type, 'text/html', 'HTML Content-Type' );

like( $response->content, qr/monoidea/, "Contains the word monoidea");

# test request to download
$request = POST(
    'http://localhost/download',
    'Content-Type' => 'form-data',
    'Content' => [
	'session_id' => 0,
	'token' => 1234,
    ]);

$response = undef;

ok( $response = request($request), 'Request to return translation');
ok( $response->is_success, 'Translation request successful 2xx' );

is( $response->content_type, 'text/html', 'HTML content type' );

like( $response->content, qr/download/, "Contains the word download");
