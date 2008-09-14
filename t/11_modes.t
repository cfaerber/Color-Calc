use Test::More tests => 4;
use Color::Calc;

is((join '-', color('red')), '0255-0-0');

$Color::Calc::MODE = 'tuple';
is((join '-', color('red')), '0255-0-0');

$Color::Calc::MODE = 'hex';
is(color('red'), 'ff0000');

$Color::Calc::MODE = 'html';
is(color('red'), 'red');
