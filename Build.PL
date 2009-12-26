#!/usr/bin/perl

use 5.006;
use strict;

use utf8;

use Module::Build;

my $b = Module::Build->new(
	'dist_name'	=> 'Color-Calc-DEPRECATED',
	'dist_author'	=> 'Claus Färber <CFAERBER@cpan.org>',
	'dist_abstract'	=> 'deprecated and obsolete modules from Color::Calc',
	'dist_version_from' => 'lib/Color/Calc/hex.pm',

	'license'	=> 'perl',

	'sign'		=> 1,
	'create_license' 	=> 1,
	'create_makefile_pl'	=> 'traditional',

    	'requires'	=> {
		'perl'		=> 5.006,
		'Color::Calc'	=> 1.060,
	},
	'resources' => {
		'homepage' 	=> 'http://search.cpan.org/dist/Color-Calc',
		'repository'	=> 'http://github.com/cfaerber/Color-Calc',
	},
);

$b->create_build_script;
