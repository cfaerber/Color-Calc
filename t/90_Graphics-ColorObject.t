use Test::More tests => 2;
use Color::Calc;

SKIP: {
  eval { require Graphics::ColorObject; };
  skip "Graphics::ColorObject not installed", 2 if $@;

  is(color_object('red')->as_RGBhex, 'FF0000');
  is(color_mix_object('red','blue')->as_RGBhex, '808000');
};  
