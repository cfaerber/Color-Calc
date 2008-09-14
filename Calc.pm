package Color::Calc;

use strict;
use Carp;
use POSIX;

use Graphics::ColorNames qw( hex2tuple tuple2hex );
use Graphics::ColorNames::HTML;

our $VERSION = '0.20';
$VERSION = eval $VERSION;

our $AUTOLOAD;
our $MODE = ();

use Exporter;

our @__subs;

BEGIN {
our @__subs = qw( blend blend_bw bw contrast contrast_bw dark get grey invert
light mix);
sub __suffixes { ($_, $_.'_tuple', $_.'_hex', $_.'_html', $_.'_object', $_.'_pdf') };

our @ISA = qw(Exporter);
our @EXPORT = map &__suffixes, ('color', map { 'color_'.$_ } @__subs);
}

my %ColorNames = ();
tie %ColorNames, 'Graphics::ColorNames';

my %__HTMLColors = ();
{
  my $table = Graphics::ColorNames::HTML::NamesRgbTable();
  %__HTMLColors = map 
    { ( sprintf('%06x', $$table{$_}) => $_ ) }
      grep { $_ ne 'fuscia' }
        keys %$table;
};

=head1 NAME

Color::Calc - Simple calculations with RGB colors.

=head1 SYNOPSIS

  use Color::Calc ();
  my $background = 'green';
  print 'background: ',Color::Calc::color_html($background),';';
  print 'border-top: solid 1px ',Color::Calc::light_html($background),';';
  print 'border-bottom: solid 1px ',Color::Calc::dark_html($background),';';
  print 'color: ',contrast_bw_html($background),';';

=head1 DESCRIPTION

The C<Color::Calc> module implements simple calculations with RGB
colors. This can be used to create a full color scheme from a few
colors.

=head2 Color Input Formats

All of the functions accept colors as parameters in the following
formats:

=over 4

=item * 

An arrayref pointing to an array with three elements in the range
C<0>..C<255> corresponding to the red, green, and blue component.

=item * 

A string containing a hexadecimal RGB value in the form 
C<#I<RRGGBB>>/C<#I<RGB>> or C<I<RGB>>/C<I<RRGGBB>>.

=item *

A color name accepted by C<Graphics::ColorNames>.

=item *

A C<PDF::API2::Color> reference.

=item *

A C<Graphics::ColorObject> reference.

=item * 

The return value of any of the public C<Color::Calc::>* functions, even if it
is a list returned by C<I<xxx>_tuple>.

=back

=head2 Color Output Formats

C<Color::Calc> can return colors in the following modes:

=over 4

=item * tuple

Returns a list of three values in the range 0..255.

=item * hex

Returns a hexadecimal RGB value in the format RRGGBB.

=item * html

Returns a value compatible with W3C's HTML and CSS specifications,
i.e.  I<#RRGGBB> or one of the sixteen color names.

=item * pdf

Returns a C<PDF::API2::Color> reference. The module
C<PDF::API2::Color> must be installed.

=item * object

Returns a C<Graphics::ColorObject> reference. The module
C<Graphics::ColorObject> must be installed.

=back

You can select the mode using one of the following methods:

=over 4

=item * Add a suffix C<_I<mode>> to the function name:

Call the function C<mix> as C<mix_hex>, for example.

=item * Set C<$Color::Calc::MODE>:

This is a global variable.

Valid values are 'tuple', 'hex', 'html', 'obj', 'pdf', or 'object'
(the default ist 'tuple' to maintain compatibility with earlier
versions).

=item * Use a different module

You can use one of the modules C<Color::Calc::hex>,
C<Color::Calc::html>, C<Color::Calc::tulpe> C<Color::Calc::obj>,
C<Color::Calc::pdf>, or C<Color::Calc::object>.

The function C<Color::Calc::html::mix> is equivalent to
C<Color::Calc::mix_html>, for example.

These modules export their functions with the C<color_> prefix by
default, just as the main module.

=back

=head2 Accessing the Functions

The functions can be accessed in several ways:

=over 4

=item *

The functions are exported by default with a prefix of C<color_>:

  use Color::Calc;
  print color_dark_hex('#FFFFFF');	# returns '808080';

=item *

If you prefer not to import the functions, you can call them by
specifying the package name; in this case, you may leave out the
prefix C<color_>:

  use Color::Calc ();
  print Color::Calc::dark_hex('#FFFFFF'); # returns '808080';
  print Color::Calc::color_dark_hex('#FFFFFF'); # returns '808080';

=back

Note that I<function> and color_I<function> are fully equivalent
except that only color_I<function> is exported by default.

=head2 Available Functions

The following functions are available:

=over 4

=item * color($color)

=item * color_get($color)

Returns the color as-is (but in the format specified). This
function can be used for color format conversion/normalisation.

=cut

sub __normtuple_in {
  return map { ($_ < 0) ? 0 : (($_ > 255) ? 255 : int($_+.5)) } @_;
}

sub __normtuple_out {
  return map { (length $_) == 3 ? '0'.$_ : $_ } __normtuple_in(@_)
}

sub __normtuple {
  return __normtuple_out(__normtuple_in(@_));
}

sub __is_col_val {
  return undef unless defined $_[0];
  return undef if $_[0] eq '';
  my ($n,$u) = POSIX::strtod($_[0]);
  return undef if $u != 0;
  return ($n <= 255) && ($n>= 0);
}

# Note: Color::Object was supported in versions before 0.2. This
# is kept for compatibility, but no longer documented.
#
# Note: versions before 0.2 allowed calling some functions (those
# with one parameter) with a list instead of an arrayref. This is
# kept for compatibility, but no longer documented.

sub __get(\@;$) {
  my ($p,$q) = @_;

  if ((ref $$p[0]) eq 'ARRAY' && $#{$$p[0]} == 0 ) {
    $$p[0] = $$p[0]->[0];
  }
  
  if ((ref $$p[0]) eq 'ARRAY' && $#{$$p[0]} == 2 ) {
    return __normtuple_in(@{shift @$p});
  }
  elsif( UNIVERSAL::isa($$p[0],'Color::Object') ||
         UNIVERSAL::isa($$p[0],'PDF::API2::Color')) {
    return (map { 255 * $_; } (shift(@{$p})->asRGB));
  }
  elsif( UNIVERSAL::isa($$p[0],'Graphics::ColorObject')) {
    return (shift(@{$p})->as_RGB255());
  }
  elsif( $#$p >= (2 + ($q||0)) && 
                      __is_col_val($$p[0]) &&
                      __is_col_val($$p[1]) &&
		      __is_col_val($$p[2])) {
    return (splice @$p, 0, 3);	 
  }	 
  elsif( $$p[0] =~ m/^#?([0-9A-F])([0-9A-F])([0-9A-F])$/i ) {
    shift @$p; 
    return (map { hex($_) * 17 } ($1,$2,$3));
  }
  elsif( $$p[0] =~ m/^#?([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])$/i ) {
    shift @$p; 
    return (map { hex($_) } ($1,$2,$3));
  }
  else {
    my $col = $ColorNames{$$p[0]};
    if($col) {
      shift @$p; 
      return hex2tuple($col);
    } else {
      carp("Invalid color name '$$p[0]'");
      return undef;
    }
  }
}

sub get_tuple { return __normtuple_out(__get(@_)); }
*color_tuple = \&get_tuple;

=item * color_invert($color)

Returns the inverse of $color.

=cut

sub invert_tuple {
  return __normtuple_out(map { 255 - $_ } __get(@_));
}

=item * color_bw($color)
=item * color_grey($color)

Converts $color to greyscale.

=cut

sub bw_tuple {
  my @c = __get(@_);
  my $g = $c[0]*.3 + $c[1]*.59 + $c[2]*.11;
  return __normtuple($g,$g,$g);
}

*grey_tuple = \&bw_tuple;
*gray_tuple = \&bw_tuple;

=item * color_mix($color1, $color2 [, $alpha])

Returns a color that is the mixture of $color1 and $color2.

The optional $alpha parameter can be a value between 0.0 (use $color1
only) and 1.0 (use $color2 only), the default is 0.5.

=cut

sub mix_tuple {
  my @c1 = (__get @_,1);
  my @c2 = (__get @_);
  my $alpha = shift(@_); $alpha = 0.5 unless defined $alpha;

  return  __normtuple(
    ($c1[0] + ($c2[0]-$c1[0])*$alpha),
    ($c1[1] + ($c2[1]-$c1[1])*$alpha),
    ($c1[2] + ($c2[2]-$c1[2])*$alpha) );
}

=item * color_light($color [, $alpha])

Returns a lighter version of $color, i.e. returns
mix($color,[255,255,255],$alpha);

The optional $alpha parameter can be a value between 0.0 (use $color
only) and 1.0 (use 'white' only), the default is 0.5.

=cut

sub light_tuple {
  return mix_tuple([__get @_],[255,255,255],shift);
}

=item * color_dark($color [, $alpha])

Returns a darker version of $color, i.e. returns
mix($color,[0,0,0],$alpha);

The optional $alpha parameter can be a value between 0.0 (use $color
only) and 1.0 (use 'black' only), the default is 0.5.

=cut

sub dark_tuple {
  return mix_tuple([__get @_],[0,0,0],shift);
}

=item * color_contrast($color [, $cut])

Returns a color that has the highest possible contrast to the input
color.

This is done by setting the red, green, and blue values to 0 if the
corresponding value in the input is above C<($cut * 255)> and to 255 otherwise.

The default for C<$cut> is .5, representing a cutoff between 127 and 128.

=cut

sub contrast_tuple {
  my @rgb = __get @_;
  my $cut = (shift || .5) * 255;
  return map { $_ >= $cut ? 0 : '0255' } @rgb;
}

=item * color_contrast_bw($color [, $cut])

Returns black or white, whichever has the higher contrast to $color.

This is done by setting returning black if the grey value of $color is above
C<($cut * 255)> and white otherwise.

The default for C<$cut> is .5, representing a cutoff between 127 and 128.

=cut

sub contrast_bw_tuple {
  return contrast_tuple([grey_tuple(@_)], shift);
}

=item * color_blend($color [, $alpha])

Returns a color that blends into the background, i.e. it returns
mix($color,contrast($color),$alpha).

The optional $alpha parameter can be a value between 0.0 (use $color
only) and 1.0 (use C<contrast($color)> only), the default is 0.5.

The idea is that C<$color> is the foreground color, so C<contrast($color)> is
similar to the background color. Mixing them returns a color somewhere between
them.
You might want to use mix($color, $background, $alpha) instead if you know the
real background color.

=cut

sub blend_tuple {
  my @c1 = __get @_;
  return mix_tuple(\@c1,[contrast(\@c1)],shift);
}

=item * color_blend_bw($color [, $alpha])

Returns a mix of $color and black or white, whichever has the higher contrast
to $color.

The optional $alpha parameter can be a value between 0.0 (use $color
only) and 1.0 (use black/white only), the default is 0.5.

=back

=cut

sub blend_bw_tuple {
  my @c = __get @_;
  return mix_tuple(\@c,[contrast_bw(\@c)],shift);
}

BEGIN {

foreach my $sub (('color',@__subs)) {
  no strict 'refs';
  my $name = $sub.'_tuple';

  my $hex = $sub.'_hex';
  *$hex = sub { return tuple2hex(&$name(@_)); };

  my $html = $sub.'_html';
  *$html = sub {
    my $col = lc(tuple2hex(&$name(@_)));
    return $__HTMLColors{$col} || '#'.$col;
  };

  my $obj = $sub.'_object';
  *$obj = sub {
    eval { require Graphics::ColorObject; };
    return Graphics::ColorObject->new_RGB255( [&$name(@_)] );
  };

  my $pdf = $sub.'_pdf';
  *$pdf = sub {
    eval { require PDF::API2::Color; };
    return  PDF::API2::Color->newRGB( map { $_ / 255 } (&$name(@_)));
  };

  *$sub = sub {
    my $name = $sub.'_'.(lc($MODE || 'tuple'));
    return (&$name(@_));
  };
}

foreach my $sub ( map &__suffixes, @__subs )
{
  no strict 'refs';
  my $csub = "color_$sub";
  *$csub = \&$sub;
};

}

=head1 SEE ALSO

L<Graphics::ColorNames> (required);
L<Color::Object> (optional)

=head1 AUTHOR

Claus A. Färber <perl@faerber.muc.de>

=head1 COPYRIGHT

Copyright © 2004 Claus A. Färber All rights reserved. This program
is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
