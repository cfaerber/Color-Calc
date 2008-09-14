use Test::More tests => 6;
use Color::Calc::html;

is(color('red'), 'red');
is(color([255,0,0]), 'red');
is(color('F00'), 'red');
is(color('FF0000'), 'red');
is(color('#F00'), 'red');
is(color('#FF0000'), 'red');
