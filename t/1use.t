use Test::More tests => 3;
BEGIN { use_ok('Color::Calc') }; 
is(uc(color_contrast_hex('#000000')),'FFFFFF');
is(uc(color_contrast_html('#000000')),'#FFFFFF');
