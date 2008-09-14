# $Id: 30_color_schemes_oo.t,v 1.2 2005/04/09 20:49:59 cfaerber Exp $
#
use Test::More tests => 2;
use Color::Calc();


my $cc = Color::Calc->new( 'OutputFormat' => 'html' );
is($cc->get	('green'),		'lime');

$cc = Color::Calc->new( 'ColorScheme' => 'HTML', 'OutputFormat' => 'html' );
is($cc->get	('green'),		'green');
