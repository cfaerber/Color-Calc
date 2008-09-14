# $Id: Makefile.PL,v 1.5 2006/11/12 21:25:41 cfaerber Exp $
#
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Color::Calc',
    'VERSION_FROM'	=> 'Calc.pm', # finds $VERSION
    'PREREQ_PM'		=> {
		'Graphics::ColorNames'	=> 0.32,
		'Graphics::ColorNames::WWW' => 0.01,
		'Params::Validate'	=> 0.75,
	},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'Calc.pm', # retrieve abstract from module
       AUTHOR     => 'Claus Färber <perl@faerber.muc.de>') : ()),
);
