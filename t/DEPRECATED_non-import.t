use Test::More tests => 49;
use Test::NoWarnings;

use Color::Calc::hex();
use Color::Calc::html();
use Color::Calc::tuple();

is(Color::Calc::hex::get		('red'),		'ff0000');
is(Color::Calc::hex::mix		('red','blue'),		'800080');

is(Color::Calc::hex::blend_bw	('red'),		'ff8080');
is(Color::Calc::hex::blend		('red'), 		'808080');
is(Color::Calc::hex::bw		('red'),		'4d4d4d');
is(Color::Calc::hex::contrast_bw	('red'),		'ffffff');
is(Color::Calc::hex::contrast	('red'),		'00ffff');
is(Color::Calc::hex::dark		('red'),		'800000');
is(Color::Calc::hex::gray		('red'),		'4d4d4d');
is(Color::Calc::hex::grey		('red'),		'4d4d4d');
is(Color::Calc::hex::invert		('red'),		'00ffff');
is(Color::Calc::hex::light		('red'),		'ff8080');

is(Color::Calc::html::get		('F00'),		'red');
is(Color::Calc::html::mix		('red','blue'),		'purple');

is(Color::Calc::html::blend_bw	('red'),		'#ff8080');
is(Color::Calc::html::blend		('red'), 		'gray');
is(Color::Calc::html::bw		('red'),		'#4d4d4d');
is(Color::Calc::html::contrast_bw	('red'),		'white');
is(Color::Calc::html::contrast	('red'),		'aqua');
is(Color::Calc::html::dark		('red'),		'maroon');
is(Color::Calc::html::gray		('red'),		'#4d4d4d');
is(Color::Calc::html::grey		('red'),		'#4d4d4d');
is(Color::Calc::html::invert		('red'),		'aqua');
is(Color::Calc::html::light		('red'),		'#ff8080');

SKIP: {
eval { require Graphics::ColorObject; };
skip "Graphics::ColorObject not installed", 12 if $@;
require Color::Calc::object;

is(lc Color::Calc::object::get		('red')->as_RGBhex,		'ff0000');
is(lc Color::Calc::object::mix		('red','blue')->as_RGBhex,	'800080');

is(lc Color::Calc::object::blend_bw	('red')->as_RGBhex,		'ff8080');
is(lc Color::Calc::object::blend	('red')->as_RGBhex, 		'808080');
is(lc Color::Calc::object::bw		('red')->as_RGBhex,		'4d4d4d');
is(lc Color::Calc::object::contrast_bw	('red')->as_RGBhex,		'ffffff');
is(lc Color::Calc::object::contrast	('red')->as_RGBhex,		'00ffff');
is(lc Color::Calc::object::dark	('red')->as_RGBhex,		'800000');
is(lc Color::Calc::object::gray	('red')->as_RGBhex,		'4d4d4d');
is(lc Color::Calc::object::grey	('red')->as_RGBhex,		'4d4d4d');
is(lc Color::Calc::object::invert	('red')->as_RGBhex,		'00ffff');
is(lc Color::Calc::object::light	('red')->as_RGBhex,		'ff8080');
}

is(join(',',Color::Calc::tuple::get		('red')),		'0255,0,0');
is(join(',',Color::Calc::tuple::mix		('red','blue')),	'0128,0,0128');

is(join(',',Color::Calc::tuple::blend_bw	('red')),		'0255,0128,0128');
is(join(',',Color::Calc::tuple::blend		('red')), 		'0128,0128,0128');
is(join(',',Color::Calc::tuple::bw		('red')),		'77,77,77');
is(join(',',Color::Calc::tuple::contrast_bw	('red')),		'0255,0255,0255');
is(join(',',Color::Calc::tuple::contrast	('red')),		'0,0255,0255');
is(join(',',Color::Calc::tuple::dark		('red')),		'0128,0,0');
is(join(',',Color::Calc::tuple::gray		('red')),		'77,77,77');
is(join(',',Color::Calc::tuple::grey		('red')),		'77,77,77');
is(join(',',Color::Calc::tuple::invert	('red')),		'0,0255,0255');
is(join(',',Color::Calc::tuple::light		('red')),		'0255,0128,0128');
