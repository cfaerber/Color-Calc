use Test::More tests => 6;
use Color::Calc::hex;

is(color('red'), 'ff0000');
is(color([255,0,0]), 'ff0000');
is(color('F00'), 'ff0000');
is(color('FF0000'), 'ff0000');
is(color('#F00'), 'ff0000');
is(color('#FF0000'), 'ff0000');
