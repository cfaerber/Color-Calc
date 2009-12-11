use Test::More tests => 3;
use Test::NoWarnings;
use Color::Calc();


my $cc = Color::Calc->new( 'OutputFormat' => 'html' );
is($cc->get	('green'),		'lime');

$cc = Color::Calc->new( 'ColorScheme' => 'HTML', 'OutputFormat' => 'html' );
is($cc->get	('green'),		'green');
