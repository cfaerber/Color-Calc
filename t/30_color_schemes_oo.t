use Test::More tests => 2;
use Color::Calc();


my $cc = Color::Calc->new( 'OutputFormat' => 'html' );
is($cc->get	('green'),		'lime');

$cc = Color::Calc->new( 'ColorScheme' => 'HTML', 'OutputFormat' => 'html' );
is($cc->get	('green'),		'green');
