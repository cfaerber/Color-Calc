# $Id: 20_input_formats_oo.t,v 1.2 2005/04/09 20:49:59 cfaerber Exp $
#
use Test::More tests => 8;
use Color::Calc();
my $cc = Color::Calc->new( 'OutputFormat' => 'hex' );

is($cc->mix		('F00','00F'),		'800080');
is($cc->mix		('#F00','#00F'),	'800080');
is($cc->mix		('FF0000','0000FF'),	'800080');
is($cc->mix		('#FF0000','#0000FF'),	'800080');
is($cc->mix		([255,0,0],[0,0,255]),	'800080');
is($cc->mix		('0255',0,0,0,0,255),	'800080');
is($cc->mix		(['0255',0,0],0,0,255),	'800080');
is($cc->mix		('0255',0,0,[0,0,255]),	'800080');
