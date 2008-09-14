# $Id: Makefile.PL,v 1.10 2006/12/10 21:29:45 cfaerber Exp $
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
       'AUTHOR'     	=> 'Claus Färber <CFAERBER@cpan.org>',
    ) : ()),
);


sub MY::postamble {
return <<EOF
release: release-sf release-cpan

release-cpan:
	cpan-upload \$(DISTVNAME).tar\$(SUFFIX)

release-sf:
	sf-upload -groupid 128328 -packageid 140459 -r \$(VERSION) -cf Changes -nf README -f \$(DISTVNAME).tar\$(SUFFIX)
EOF
}
