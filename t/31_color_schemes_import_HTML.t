# $Id: 31_color_schemes_import_HTML.t,v 1.2 2005/04/09 20:49:59 cfaerber Exp $
#
use Test::More tests => 1;
use Color::Calc('ColorScheme' => 'HTML', 'OutputFormat' => 'html');
is(color_get	('green'),		'green');
