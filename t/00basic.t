# $Id: 00_basic.t,v 1.5 2005/04/09 20:49:58 cfaerber Exp $
#
use Test::More tests => 2;

use_ok('Color::Calc');

my $cc = new Color::Calc;
isa_ok($cc, 'Color::Calc');
