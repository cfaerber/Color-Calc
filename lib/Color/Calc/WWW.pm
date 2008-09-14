# $Id: WWW.pm,v 1.5 2008/09/14 12:30:22 cfaerber Exp $
#
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

=head1 AUTHOR/LICENSE

Copyright © 2004-2008 Claus Färber <CFAERBER@cpan.org>

This module is free software; you can redistribute it and/or
modify it under the terms of either the GNU General Public License
as published by the Free Software Foundation; either version 1, or
(at your option) any later version, or the "Artistic License".

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
MA 02110-1301, USA.

=cut

1;

