# $Id$
#
use Test::More tests => 1;
use Color::Calc('ColorScheme' => 'HTML', 'OutputFormat' => 'html');
is(color_get	('green'),		'green');
