use Test::More tests => 2;
use Color::Calc;

SKIP: {

no warnings 'redefine';
  eval { require PDF::API2::Color; };
  skip "PDF::API2::Color not installed", 2 if $@;

  is(color_pdf('red')->asHex, '#FF0000');
  is(color_mix_pdf('red','blue')->asHex, '#800080');
};  
