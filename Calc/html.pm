# $Id: html.pm,v 1.2 2005/04/09 20:49:58 cfaerber Exp $
#
package Color::Calc::html;

use strict;
use Carp;

use Exporter;
use Color::Calc();

our @ISA = qw(Exporter);
our @EXPORT = ('color', map { 'color_'.$_ } @Color::Calc::__subs);

*color = \&Color::Calc::color_html;

foreach my $sub (@Color::Calc::__subs) {
  my $su1 = 'color_'.$sub;
  my $dst = 'Color::Calc::'.$sub.'_html';

  no strict 'refs';
  *$sub = \&$dst;
  *$su1 = \&$dst;
};

1;
