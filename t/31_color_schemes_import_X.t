use Test::More tests => 2;
use Color::Calc('OutputFormat' => 'html' );
is($cc->get	('green'),		'lime');
