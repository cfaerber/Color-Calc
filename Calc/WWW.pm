package Color::Calc::WWW;

use strict;
use Carp;

use Exporter;
use Color::Calc('OutputFormat' => 'html', 'ColorScheme' => 'WWW');

our @ISA = qw(Exporter);
our @EXPORT = ('color', map { 'color_'.$_ } @Color::Calc::__subs);

1;
