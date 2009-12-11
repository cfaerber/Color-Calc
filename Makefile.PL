use 5.006;
use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Color::Calc',
    'AUTHOR'     	=> 'Claus Faerber <CFAERBER@cpan.org>',
    'LICENSE'		=> 'perl',

    'VERSION_FROM'	=> 'lib/Color/Calc.pm',
    'ABSTRACT_FROM' 	=> 'lib/Color/Calc.pm',

    'PREREQ_PM'		=> {
		'Graphics::ColorNames'	=> 0.32,
		'Graphics::ColorNames::WWW' => 0.01,
		'Params::Validate'	=> 0.75,
	},

$ExtUtils::MakeMaker::VERSION < 6.18 ? () : (
	'SIGN'		=> 1,
    ),

$ExtUtils::MakeMaker::VERSION < 6.45 ? () : (
	'META_MERGE'	=> { 
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
	    },
    ),
);

sub MY::postamble {
return <<EOF
release: git-tag release-cpan

git-tag:
	git tag \$(DISTVNAME)

release-cpan:
	cpan-upload \$(DISTVNAME).tar\$(SUFFIX)
EOF
}
