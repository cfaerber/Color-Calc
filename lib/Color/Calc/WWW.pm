package Color::Calc::WWW;

use strict;
use utf8;
use warnings;
use Carp;

use Exporter;
use Color::Calc('OutputFormat' => 'html', 'ColorScheme' => 'WWW');

our $VERSION = 1.05;

our @ISA = qw(Exporter);
our @EXPORT = ('color', map { 'color_'.$_ } @Color::Calc::__subs);

=encoding utf8

=head1 NAME

Color::Calc::WWW - Simple calculations with colors for the WWW.

=head1 SYNOPSIS

  use Color::Calc::WWW;
  my $background = 'green';
  print 'background: ', color($background),';';
  print 'border-top: solid 1px ', color_light($background),';';
  print 'border-bottom: solid 1px ', color_dark($background),';';
  print 'color: ', color_contrast_bw($background),';';

=head1 DESCRIPTION

The C<Color::Calc::WWW> module implements simple calculations with RGB colors
for the World Wide Web. This can be used to create a full color scheme from a
few colors.

=head1 FUNCTIONS

=over

=item color_I<*>($input)

  See L<Color::Calc> for a list of available calculation functions.

=item color($input)

  Shorthand for C<color_get>.

=back

=head1 AUTHOR

Claus Färber <CFAERBER@cpan.org>

=head1 LICENSE

Copyright © 2004-2009 Claus Färber. All rights reserved.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;

