package Color::Calc::tuple;

use strict;
use warnings;
use Carp;

use Exporter;
use Color::Calc();

our $VERSION = 1.052;

our @ISA = qw(Exporter);
our @EXPORT = ('color', map { 'color_'.$_ } @Color::Calc::__subs);

*color = \&Color::Calc::color_tuple;

foreach my $sub (@Color::Calc::__subs) {
  my $su1 = 'color_'.$sub;
  my $dst = 'Color::Calc::'.$sub.'_tuple';

  no strict 'refs';
  *$sub = \&$dst;
  *$su1 = \&$dst;
};

1;
__END__

=head1 NAME

Color::Calc::tuple - DEPRECATED: Simple calculations with colors (output as list/tuple)

=head1 SYNOPSIS

  use Color::Calc::tuple;
  print join ',', color( 'pink' );	# prints '0255,0192,0203'

=head1 DESCRIPTION

This module is deprecated as it does not allow selecting the scheme of
recognized color names, which defaults to L<Graphics::ColorNames::X> and is
incompatible with HTML's color names.

This module is nearly identical to using the following:

  use Color::Calc('ColorScheme' => 'X', 'OutputFormat' => 'tuple');

However, this module also makes the functions available when not imported:

  use Color::Calc::tuple();		# don't import
  Color::Calc::tuple::color('F00');

=head1 AUTHOR

Claus FE<auml>rber <CFAERBER@cpan.org>

=head1 LICENSE

Copyright 2004-2009 Claus FE<auml>rber.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
