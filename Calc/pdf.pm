# $Id: pdf.pm,v 1.3 2006/11/13 23:06:48 cfaerber Exp $
#
package Color::Calc::pdf;

use strict;
use Carp;

use Exporter;
use Color::Calc();

our @ISA = qw(Exporter);
our @EXPORT = ('color', map { 'color_'.$_ } @Color::Calc::__subs);

*color = \&Color::Calc::color_pdf;

foreach my $sub (@Color::Calc::__subs) {
  my $su1 = 'color_'.$sub;
  my $dst = 'Color::Calc::'.$sub.'_pdf';

  no strict 'refs';
  *$sub = \&$dst;
  *$su1 = \&$dst;
};

1;
