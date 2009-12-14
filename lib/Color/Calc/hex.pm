package Color::Calc::hex;

use strict;
use warnings;
use Carp;

use Exporter;
use Color::Calc();

our $VERSION = 1.052;

our @ISA = qw(Exporter);
our @EXPORT = ('color', map { 'color_'.$_ } @Color::Calc::__subs);

*color = \&Color::Calc::color_hex;

foreach my $sub (@Color::Calc::__subs) {
  my $su1 = 'color_'.$sub;
  my $dst = 'Color::Calc::'.$sub.'_hex';

  no strict 'refs';
  *$sub = \&$dst;
  *$su1 = \&$dst;
};

1;
__END__

=encoding utf8

=head1 NAME

Color::Calc::hex - DEPRECATED: Simple calculations with colors (output in hex)

=head1 SYNOPSIS

  use Color::Calc::hex;
  print color( 'pink' );	# prints 'ffc0cb'

=head1 DESCRIPTION

This module is deprecated as it does not allow selecting the scheme of
recognized color names, which defaults to L<Graphics::ColorNames::X> and is
incompatible with HTML's color names.

This module is nearly identical to using the following:

  use Color::Calc('ColorScheme' => 'X', 'OutputFormat' => 'hex');

However, this module also makes the functions available when not imported:

  use Color::Calc::hex();		# don't import
  Color::Calc::hex::color('F00');

=head1 AUTHOR

Claus Färber <CFAERBER@cpan.org>

=head1 LICENSE

Copyright © 2004-2009 Claus Färber.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
