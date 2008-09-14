use Test::More tests => 3;
use Color::Calc;

is((join '-', color_tuple('red')), '0255-0-0');
is(color_hex([255,0,0]), 'ff0000');
is(color_html([255,0,0]), 'red');
