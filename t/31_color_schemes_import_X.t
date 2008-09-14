# $Id: 31_color_schemes_import_X.t,v 1.3 2005/04/09 20:49:59 cfaerber Exp $
#
use Test::More tests => 1;
use Color::Calc('OutputFormat' => 'html' );
is(color_get	('green'),		'lime');
