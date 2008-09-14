use Test::More tests => 2;
BEGIN { 
  use_ok('Color::Calc')
};

is(uc(color_contrast_hex('#000000')),'FFFFFF');
