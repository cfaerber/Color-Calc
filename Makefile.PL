# $Id: Makefile.PL,v 1.7 2006/11/13 21:42:16 cfaerber Exp $
#
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Color::Calc',
    'VERSION_FROM'	=> 'Calc.pm',
    'PREREQ_PM'		=> {
		'Graphics::ColorNames'	=> 0.32,
		'Graphics::ColorNames::WWW' => 0.01,
		'Params::Validate'	=> 0.75,
	},
    ($] >= 5.005 ?
      ('ABSTRACT_FROM' 	=> 'Calc.pm',
       'AUTHOR'     	=> 'Claus Färber <cfaerber@cpan.org>',
    ) : ()),
);
