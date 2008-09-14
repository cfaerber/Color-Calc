# $Id: 19_DEPRECATED_module_import_object.t,v 1.6 2006/12/10 21:29:45 cfaerber Exp $
#
use Test::More tests => 13;

SKIP: {
eval { require Graphics::ColorObject; };
skip "Graphics::ColorObject not installed", 13 if $@;
require Color::Calc::object;
import Color::Calc::object();

is(lc color_get		('red')->as_RGBhex,		'ff0000');
is(lc color		('red')->as_RGBhex,		'ff0000');
is(lc color_mix		('red','blue')->as_RGBhex,	'800080');

is(lc color_blend_bw	('red')->as_RGBhex,		'ff8080');
is(lc color_blend	('red')->as_RGBhex, 		'808080');
is(lc color_bw		('red')->as_RGBhex,		'4d4d4d');
is(lc color_contrast_bw	('red')->as_RGBhex,		'ffffff');
is(lc color_contrast	('red')->as_RGBhex,		'00ffff');
is(lc color_dark	('red')->as_RGBhex,		'800000');
is(lc color_gray	('red')->as_RGBhex,		'4d4d4d');
is(lc color_grey	('red')->as_RGBhex,		'4d4d4d');
is(lc color_invert	('red')->as_RGBhex,		'00ffff');
is(lc color_light	('red')->as_RGBhex,		'ff8080');
}
