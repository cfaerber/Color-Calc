package Color::Calc;

use strict;
use Graphics::ColorNames qw( hex2tuple tuple2hex );

our $VERSION = 0.02;
our $AUTOLOAD;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(
  color_mix	    color_mix_hex
  color_contrast    color_contrast_hex
  color_blend	    color_blend_hex
  color_invert	    color_invert_hex
  color_light	    color_light_hex
  color_dark	    color_dark_hex
);

my %ColorNames = ();
tie %ColorNames, 'Graphics::ColorNames';

=head1 NAME

Color::Calc - Simple calculations with RGB colors.

=head1 SYNOPSIS

  use Color::Calc ();
  my $background = 'green';
  print 'background: ',$background,';';
  print 'border-top: solid 1px #',Color::Calc::light_hex($background),';';
  print 'border-bottom: solid 1px #',Color::Calc::dark_hex($background),';';
  print 'color: #',contrast_hex($background),';';

=head1 DESCRIPTION

The C<Color::Calc> module implements simple calculations with RGB
colors.  This can be used to create a full color scheme from a few
colors.

=head2 Color Input Formats

All of the functions accept colors as parameters in the following formats:

=over 4

=item * 

An arrayref pointing to an array with three elements in the range 0..255
corresponding to the red, green, and blue component.

=item * 

A string containing a hexadecimal RGB value in the form of #RRGGBB or RRGGBB.

=item * 

A color name accepted by C<Graphics::ColorNames>.

=item *

A C<Color::Object> reference.

=back

Instead of an arrayref, you can also pass a list with three values for
functions that take a single parameter.

=head2 Color Output Formats

Each of the functions exists in different variants that provide different output
formats:

=over 4

=item * I<function>

Returns a list of three values in the range 0..255.

=item * I<function>_hex

Returns a hexadecimal RGB value in the format RRGGBB.

=back

=head2 Accessing the Functions

The functions can be accessed in several ways:

=over 4

=item *

The functions are exported by default with a prefix of C<color_>:

  use Color::Calc;
  print color_dark_hex('#FFFFFF');	# returns '808080';

=item *

If you prefer not to import the functions, you can call them by specifying the
package name:

  use Color::Calc ()
  print Color::Calc::dark_hex('#FFFFFF'); # returns '808080';

=back

Note that I<function> and color_I<function> are fully equivalent except that
only color_I<function> is exported by default.

=head2 Available Functions

The following functions are available:

=over 4

=item * get($color)

Returns the color as-is (but in the format specified). This
function is mostly used internally, but it's available for
completeness.

=cut

sub get
{
  if( $#_ == 2 ) {
    return @_;
  }
  elsif( UNIVERSAL::isa($_[0],'ARRAY') && $#{$_[0]} == 2 ) {
    return @{$_[0]};
  }
  elsif( UNIVERSAL::isa($_[0],'Color::Object') ) {
    return map { $_*=255;$_; } ($_[0]->asRGB);
  }
  else {
    return hex2tuple( $ColorNames{$_[0]} );
  }
}

=item * mix($color1, $color2, $alpha)

Returns a color that is the mixture of $color1 and $color2. 

The optional $alpha parameter can be a value between 0.0 (use
$color1 only) and 1.0 (use $color2 only), the default is 0.5.

=cut

sub mix {
  my @c1 = get(shift);
  my @c2 = get(shift);
  my $alpha = shift; $alpha = 0.5 unless defined $alpha;

  return(
    ($c1[0] + ($c2[0]-$c1[0])*$alpha),
    ($c1[1] + ($c2[1]-$c1[1])*$alpha),
    ($c1[2] + ($c2[2]-$c1[2])*$alpha) );
}

=item * contrast($color)

Returns a color that has the highest possible contrast to the
input color.

This is done by setting the red, green, and blue values to 0 if
the corresponding value in the input is >= 128 and to 255
otherwise.

=cut

sub contrast {
  return map { $_>=0x80 ? 0 : 255 } get(@_);
}

=item * blend($color,$alpha)

Returns a color that blends into the background by using less
contrast, i.e. it returns mix($color,contrast($color),$alpha).

The $alpha parameter is optional.

=cut

sub blend {
  return mix($_[0],[contrast($_[0])],$_[1]);
}

=item * invert($color)

Returns the inverse color.

=cut

sub invert {
  return map { 255 - $_ } get(@_);
}

=item * light($color,$alpha)

Returns a lighter version of $color, i.e. returns
mix($color,'FFFFFF',$alpha);

The $alpha parameter is optional.

=cut

sub light {
  return mix($_[0],'FFFFFF',$_[1]);
}

=item * invert($color)

Returns the inverse color.

Returns a darker version of $color, i.e. returns
mix($color,'000000',$alpha);

=cut

sub dark {
  return mix($_[0],'000000',$_[1]);
}

=back

=cut

sub AUTOLOAD 
{
  {
    no strict 'refs';

    if($AUTOLOAD =~ m/(.*)_hex$/) {
      my $name = $1;
      *$AUTOLOAD = sub {
        return tuple2hex(&$name(@_));
      };
      goto &$AUTOLOAD;
    }

    elsif($AUTOLOAD =~ m/^(.*::)colou?r_(.*)$/) {
      my $name = $1.$2;
      *$AUTOLOAD = \&$name;
      goto &$AUTOLOAD;
    }

    else {
      die 'Blubb.';
    }
  }
}

1;

__END__

=head1 AUTHOR

Claus A. Färber <perl@faerber.muc.de>

=head1 COPYRIGHT

Copyright © 2003 Claus A. Färber All rights reserved. This program
is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. 

=cut
