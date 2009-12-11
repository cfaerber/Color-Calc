package Color::Calc::object;
use Graphics::ColorObject;

use strict;
use warnings;
use Carp;

use Exporter;
use Color::Calc();

our $VERSION = 1.05;

our @ISA = qw(Exporter);
our @EXPORT = ('color', map { 'color_'.$_ } @Color::Calc::__subs);

*color = \&Color::Calc::color_object;

foreach my $sub (@Color::Calc::__subs) {
  my $su1 = 'color_'.$sub;
  my $dst = 'Color::Calc::'.$sub.'_object';

  no strict 'refs';
  *$sub = \&$dst;
  *$su1 = \&$dst;
};

1;
