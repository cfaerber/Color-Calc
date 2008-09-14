use Test::More tests => 2;

use_ok('Color::Calc');

my $cc = new Color::Calc;
isa_ok($cc, 'Color::Calc');
