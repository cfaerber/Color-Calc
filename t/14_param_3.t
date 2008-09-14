use Test::More tests => 5;
use Color::Calc;

$Color::Calc::MODE = 'hex';

#	       R     G     B    RGB  ALPHA
is(color_mix('255','000','000','000'      ),'800000');
is(color_mix('255','000','000','000', .4  ),'990000');
#	      RGB    R     G     B   ALPHA
is(color_mix('FF0','000','000','000',     ),'808000');
is(color_mix('FF0','000','000','000', .4  ),'999900');
#             RGB   RGB   ALPHA
is(color_mix('255','000','000'      ),'225555');

