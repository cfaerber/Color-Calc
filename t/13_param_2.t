use Test::More tests => 4;
use Color::Calc;

$Color::Calc::MODE = 'hex';

#               R     G     B   ALPHA
is(color_dark('255','000','000',     ),'800000');
is(color_dark('255','000','000', .4  ),'990000');

#  	       RGB  ALPHA
is(color_dark('FF0',     ),'808000');
is(color_dark('FF0', .4  ),'999900');
