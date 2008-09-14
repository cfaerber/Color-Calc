use Test::More tests => 10;
use Color::Calc::hex;

is(color_mix('black','white'), '808080');
is(color_mix('black','white',0.25), '404040');

is(color_light('white'), 'ffffff');
is(color_light('black'), '808080');
is(color_light('black',0.25), '404040');

is(color_dark('black'), '000000');
is(color_dark('white'), '808080');
is(color_dark('white',0.25), 'bfbfbf');

is(color_dark('CCCCCC'), '666666');
is(color_light('CCCCCC'), 'e6e6e6');
