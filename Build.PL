#!/usr/bin/perl

use 5.006;
use strict;

use Module::Build;

my $b = Module::Build->new(
	'module_name'	=> 'Color::Calc',
	'license'	=> 'perl',

	'sign'		=> 1,
	'create_license' => 1,
	'create_makefile_pl' => 'traditional',

    	'requires'	=> {
		'Graphics::ColorNames'	=> 0.32,
		'Graphics::ColorNames::WWW' => 0.01,
		'Params::Validate'	=> 0.75,
	},
	'build_requires' => {
		'Test::More' => 0, 
		'Test::NoWarnings' => 0,
	},
	'no_index' => {
		'directory' => 'eg'
	},
	'resources' => {
		'homepage' => 'http://search.cpan.org/dist/Color-Calc',
		'repository' => 'http://github.com/cfaerber/Color-Calc',
	},
);

$b->create_build_script;
