use Test::More tests => (13*4) + 1;
use Test::NoWarnings;
use Color::Calc();

is(Color::Calc::color_get_hex			('red'),		'ff0000');
is(Color::Calc::color_hex			('red'),		'ff0000');
is(Color::Calc::color_mix_hex			('red','blue'),		'800080');

is(Color::Calc::color_blend_bw_hex		('red'),		'ff8080');
is(Color::Calc::color_blend_hex			('red'), 		'808080');
is(Color::Calc::color_bw_hex			('red'),		'4d4d4d');
is(Color::Calc::color_contrast_bw_hex		('red'),		'ffffff');
is(Color::Calc::color_contrast_hex		('red'),		'00ffff');
is(Color::Calc::color_dark_hex			('red'),		'800000');
is(Color::Calc::color_gray_hex			('red'),		'4d4d4d');
is(Color::Calc::color_grey_hex			('red'),		'4d4d4d');
is(Color::Calc::color_invert_hex		('red'),		'00ffff');
is(Color::Calc::color_light_hex			('red'),		'ff8080');

is(Color::Calc::color_get_html			('F00'),		'red');
is(Color::Calc::color_html			('F00'),		'red');
is(Color::Calc::color_mix_html			('red','blue'),		'purple');

is(Color::Calc::color_blend_bw_html		('red'),		'#ff8080');
is(Color::Calc::color_blend_html		('red'), 		'gray');
is(Color::Calc::color_bw_html			('red'),		'#4d4d4d');
is(Color::Calc::color_contrast_bw_html		('red'),		'white');
is(Color::Calc::color_contrast_html		('red'),		'aqua');
is(Color::Calc::color_dark_html			('red'),		'maroon');
is(Color::Calc::color_gray_html			('red'),		'#4d4d4d');
is(Color::Calc::color_grey_html			('red'),		'#4d4d4d');
is(Color::Calc::color_invert_html		('red'),		'aqua');
is(Color::Calc::color_light_html		('red'),		'#ff8080');

SKIP: {
eval { require Graphics::ColorObject; };
skip "Graphics::ColorObject not installed", 13 if $@;

is(lc Color::Calc::color_get_object		('red')->as_RGBhex,		'ff0000');
is(lc Color::Calc::color_object			('red')->as_RGBhex,		'ff0000');
is(lc Color::Calc::color_mix_object		('red','blue')->as_RGBhex,	'800080');

is(lc Color::Calc::color_blend_bw_object	('red')->as_RGBhex,		'ff8080');
is(lc Color::Calc::color_blend_object		('red')->as_RGBhex, 		'808080');
is(lc Color::Calc::color_bw_object		('red')->as_RGBhex,		'4d4d4d');
is(lc Color::Calc::color_contrast_bw_object	('red')->as_RGBhex,		'ffffff');
is(lc Color::Calc::color_contrast_object	('red')->as_RGBhex,		'00ffff');
is(lc Color::Calc::color_dark_object		('red')->as_RGBhex,		'800000');
is(lc Color::Calc::color_gray_object		('red')->as_RGBhex,		'4d4d4d');
is(lc Color::Calc::color_grey_object		('red')->as_RGBhex,		'4d4d4d');
is(lc Color::Calc::color_invert_object		('red')->as_RGBhex,		'00ffff');
is(lc Color::Calc::color_light_object		('red')->as_RGBhex,		'ff8080');
}

is(join(',',Color::Calc::color_get_tuple	('red')),		'0255,0,0');
is(join(',',Color::Calc::color_tuple		('red')),		'0255,0,0');
is(join(',',Color::Calc::color_mix_tuple	('red','blue')),	'0128,0,0128');

is(join(',',Color::Calc::color_blend_bw_tuple	('red')),		'0255,0128,0128');
is(join(',',Color::Calc::color_blend_tuple	('red')), 		'0128,0128,0128');
is(join(',',Color::Calc::color_bw_tuple		('red')),		'77,77,77');
is(join(',',Color::Calc::color_contrast_bw_tuple('red')),		'0255,0255,0255');
is(join(',',Color::Calc::color_contrast_tuple	('red')),		'0,0255,0255');
is(join(',',Color::Calc::color_dark_tuple	('red')),		'0128,0,0');
is(join(',',Color::Calc::color_gray_tuple	('red')),		'77,77,77');
is(join(',',Color::Calc::color_grey_tuple	('red')),		'77,77,77');
is(join(',',Color::Calc::color_invert_tuple	('red')),		'0,0255,0255');
is(join(',',Color::Calc::color_light_tuple	('red')),		'0255,0128,0128');
