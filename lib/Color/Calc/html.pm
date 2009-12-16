package Color::Calc::html;

use strict;
use warnings;
use Carp;

use Exporter;
use Color::Calc();

our $VERSION = 1.052;

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
__END__

=head1 NAME

Color::Calc::html - DEPRECATED: Simple calculations with colors (output in html)

=head1 SYNOPSIS

  use Color::Calc::html;
  print color( 'green' );	# prints 'lime', not 'green'
  print color( 'lime' );	# warns about an unknown color name

=head1 DESCRIPTION

This module is deprecated as it does not allow selecting the scheme of
recognized color names, which defaults to L<Graphics::ColorNames::X> and is
incompatible with HTML's color names.

Yes, you've read correctly: This module does not recognize HTML color names
correctly. See L<http://en.wikipedia.org/wiki/X11_color_names#Color%20names%20that%20clash%20between%20X11%20and%20HTML/CSS>
for color names that are different.

This module is nearly identical to using the following:

  use Color::Calc('ColorScheme' => 'X', 'OutputFormat' => 'html');

However, this module also makes the functions available when not imported:

  use Color::Calc::html();		# don't import
  Color::Calc::html::color('F00');

=head1 AUTHOR

Claus FE<auml>rber <CFAERBER@cpan.org>

=head1 LICENSE

Copyright 2004-2009 Claus FE<auml>rber.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
