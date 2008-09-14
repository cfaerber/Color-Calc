# $Id$
#
use Test::More tests => 1;
use Color::Calc('OutputFormat' => 'html' );
is(color_get	('green'),		'lime');
