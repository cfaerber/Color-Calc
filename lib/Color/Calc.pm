package Color::Calc;

use strict;
use utf8;
use warnings;

use Carp;
use Exporter;
use Params::Validate qw(:all);
use POSIX;

use Graphics::ColorNames qw( hex2tuple tuple2hex );
use Graphics::ColorNames::HTML;

our $VERSION = '1.052';
$VERSION = eval $VERSION;

our $MODE = ();

my %__HTMLColors = ();
our @__subs = qw( blend blend_bw bw contrast contrast_bw dark get grey gray invert light mix );

my %__formats = (
  'tuple'	=> sub { return __normtuple_out(@_); },
  'hex'		=> sub { return tuple2hex((@_)); },
  'html'	=> sub { my $col = lc(tuple2hex((@_))); return $__HTMLColors{$col} || '#'.$col; },
  'object'	=> sub { eval { require Graphics::ColorObject; }; return Graphics::ColorObject->new_RGB255( [(@_)] ); },
  'obj'		=> sub { eval { require Color::Object; }; return Color::Object->newRGB(map { 255*$_; } @_); },
  'pdf'		=> sub { return '#'.(tuple2hex(@_)) },
);

my @__formats = keys %__formats;
my $__formats_re = join('|', @__formats,'__MODEvar');

{
  my $table = Graphics::ColorNames::HTML::NamesRgbTable();
  %__HTMLColors = map 
    { ( sprintf('%06x', $$table{$_}) => $_ ) }
      grep { $_ ne 'fuscia' }
        keys %$table;
};

our @EXPORT = ('color', map({"color_$_"} @__formats, map({my $s=$_; (map{$s.'_'.$_} @__formats)} @__subs), @__subs));
our @ISA = ('Exporter');

my %new_param = (
  'ColorScheme' => { type => SCALAR, optional => 1 },
  'OutputFormat' => { type => SCALAR, untaint => 1, regexp => qr($__formats_re), optional => 1 },
);

sub new {
  my $pkg = shift; validate(@_, \%new_param);
  my $self = {@_}; bless($self, $pkg);

  if(!ref($self->{'ColorScheme'})) {
    my %ColorNames;
    tie %ColorNames, 'Graphics::ColorNames', ($self->{'ColorScheme'} || 'X');
    $self->{'ColorScheme'} = \%ColorNames;
  }

  $self->set_output_format($self->{'OutputFormat'} || 'tuple');

  return $self;
}

my $__default_object = undef;
sub __get_default {
  $__default_object = __PACKAGE__->new('OutputFormat' => '__MODEvar') unless $__default_object;
  return $__default_object;
}

my $__tuple_object = undef;
sub __get_tuple {
  $__tuple_object = __PACKAGE__->new('OutputFormat' => 'tuple') unless $__tuple_object;
  return $__tuple_object;
}

my %import_param = ( 
  %new_param,
  'Prefix' =>  { type => SCALAR, optional => 1, regexp => qr/^[[:alpha:]\d]\w*$/ },
  '__Prefix' =>  { type => SCALAR, optional => 1, regexp => qr/^[[:alpha:]\d]\w*$/ },
  '__Suffix' =>  { type => SCALAR, optional => 1, regexp => qr/^\w+$/ },
);

my %import_param_names = map { ($_=>1) } keys %import_param;

sub import {
  my $pkg = shift;
  if(!@_ || !exists $import_param_names{$_[0]}) { 
    local $Exporter::ExportLevel; $Exporter::ExportLevel++;
    return Exporter::import($pkg, @_);
  }
  return __import(scalar caller(0),@_) ? 1 : 0;
}

sub __import {
  my $pkg = shift;
  validate(@_, \%import_param);
  my %param = @_;
  
  my $std_prefix =  (exists $param{'Prefix'}) ? $param{'Prefix'} : 'color'; 
  delete $param{'Prefix'};

  my $prefix =  (exists $param{'__Prefix'}) ? $param{'__Prefix'} : $std_prefix ? $std_prefix.'_' : '';
  delete $param{'__Prefix'};
  my $suffix =  (exists $param{'__Suffix'}) ? $param{'__Suffix'} : ''; 
  delete $param{'__Suffix'};

  my $obj = new(__PACKAGE__, %param);

  {
    no strict 'refs';
    {
      $prefix = $pkg.'::'.$prefix;
      foreach my $sub (@__subs) {
        my $name = $prefix.$sub.$suffix;
        *$name = sub { $obj->$sub(@_); };
      };
    };
    
    if($std_prefix) {
      my $name = $pkg.'::'.$std_prefix.$suffix;
      *$name = sub { $obj->get(@_); };
    }
  }
  return 1;
}


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

sub __get {
  my ($self,$p,$q) = @_;

  if ((ref $$p[0]) eq 'ARRAY' && $#{$$p[0]} == 0 ) {
    $$p[0] = $$p[0]->[0];
  }
  
  if ((ref $$p[0]) eq 'ARRAY' && $#{$$p[0]} == 2 ) {
    return __normtuple_in(@{shift @$p});
  }
  elsif( my $f255 = UNIVERSAL::can($$p[0],'asRGB255')
              || UNIVERSAL::can($$p[0],'as_RGB255') ) {
    return ($f255->(shift(@{$p})));
  }
  elsif( my $f1 = UNIVERSAL::can($$p[0],'asRGB')
              || UNIVERSAL::can($$p[0],'as_RGB') ) {
    return (map { 255 * $_; } $f1->(shift(@{$p})));
  }
  elsif( $#$p >= (2 + ($q||0)) && 
                      __is_col_val($$p[0]) &&
                      __is_col_val($$p[1]) &&
		      __is_col_val($$p[2])) {
    return (splice @$p, 0, 3);	 
  }	 
  elsif( $$p[0] =~ m/^#?(([0-9A-F][0-9A-F][0-9A-F])+)$/i ) {
    shift @$p; 
    my $hh = $1; my $hl = (length $hh)/3;
    return map { hex($_) * 255.0 / hex('F' x $hl) }
      (substr($hh,0,$hl), substr($hh,$hl,$hl), substr($hh,2*$hl));
  }
  else {
    my $col = $self->{'ColorScheme'}->{$$p[0]};
    if($col) {
      shift @$p; 
      return hex2tuple($col);
    } else {
      carp("Invalid color name '$$p[0]'");
      return undef;
    }
  }
}

sub set_output_format {
  validate_pos(@_, { isa => __PACKAGE__ }, { type => SCALAR, regexp => qr($__formats_re) });
  my $self = shift;

  my $old = $self->{'OutputFormat'};
  $self->{'OutputFormat'} = shift;

  $self->{'__put'} = $self->{'OutputFormat'} eq '__MODEvar' 
    ? sub{ return $__formats{$MODE || 'tuple'}->(@_); }
    : $__formats{$self->{'OutputFormat'}};
 
   return $old;
}

sub __put {
  my $self = shift;
  return $self->{'__put'}->(__normtuple_in(@_));
}

sub __get_self {
  if(UNIVERSAL::isa($_[0]->[0], __PACKAGE__)) {
    return shift @{$_[0]};
  } else {
    return __get_default;
  }
}

sub get { 
  my $self = __get_self(\@_); 
  return $self->__put($self->__get(\@_)); 
}

sub invert {
  my $self = __get_self(\@_);
  return $self->__put(map { 255 - $_ } $self->__get(\@_));
}

sub bw {
  my $self = __get_self(\@_);
  my @c = $self->__get(\@_);
  my $g = $c[0]*.3 + $c[1]*.59 + $c[2]*.11;
  return $self->__put(__normtuple($g,$g,$g));
}

*grey = \&bw;
*gray = \&bw;

sub mix {
  my $self = __get_self(\@_);
  my @c1 = ($self->__get(\@_,1));
  my @c2 = ($self->__get(\@_));
  my $alpha = shift(@_); $alpha = 0.5 unless defined $alpha;

  return $self->__put(__normtuple(
    ($c1[0] + ($c2[0]-$c1[0])*$alpha),
    ($c1[1] + ($c2[1]-$c1[1])*$alpha),
    ($c1[2] + ($c2[2]-$c1[2])*$alpha) ));
}

sub light {
  my $self = __get_self(\@_);
  return $self->__put(__get_tuple->mix([$self->__get(\@_)],[255,255,255],shift));
}

sub dark {
  my $self = __get_self(\@_);
  return $self->__put(__get_tuple->mix([$self->__get(\@_)],[0,0,0],shift));
}

sub contrast {
  my $self = __get_self(\@_);
  my @rgb = $self->__get(\@_);
  my $cut = (shift || .5) * 255;
  return $self->__put(map { $_ >= $cut ? 0 : '0255' } @rgb);
}

sub contrast_bw {
  my $self = __get_self(\@_);
  my @rgb = $self->__get(\@_);
  return $self->__put(__get_tuple->contrast([__get_tuple->bw(@rgb)], shift));
}

sub blend {
  my $self = __get_self(\@_);
  my @c1 = $self->__get(\@_);
  return $self->mix(\@c1,[__get_tuple->contrast(\@c1)],shift);
}

sub blend_bw {
  my $self = __get_self(\@_);
  my @c = $self->__get(\@_);
  return $self->mix(\@c,[__get_tuple->contrast_bw(\@c)],shift);
}

foreach my $format (@__formats) {
  __import(__PACKAGE__, 'Prefix' => 'color', '__Suffix' => "_$format", 'OutputFormat' => $format);
  __import(__PACKAGE__, 'Prefix' => '',      '__Suffix' => "_$format", 'OutputFormat' => $format);
}

__import(__PACKAGE__, 'Prefix' => 'color', 'OutputFormat' => '__MODEvar');

1;
__END__

=head1 NAME

Color::Calc - Simple calculations with RGB colors.

=head1 SYNOPSIS

  use Color::Calc ();
  my $background = 'green';
  print 'background: ',Color::Calc::color_html($background),";\n";
  print 'border-top: solid 1px ',Color::Calc::light_html($background),";\n";
  print 'border-bottom: solid 1px ',Color::Calc::dark_html($background),";\n";
  print 'color: ',Color::Calc::contrast_bw_html($background),";\n";

=head1 DESCRIPTION

The C<Color::Calc> module implements simple calculations with RGB colors. This
can be used to create a full color scheme from a few colors.

=head2 USAGE

=head3 Constructors

=over

=item Color::Calc->new( ... )

This class method creates a new C<Color::Calc> object.

  use Color::Calc();
  my $cc = new Color::Calc( 'ColorScheme' => 'X', OutputFormat => 'HTML' );
  print $cc->invert( 'white' );

It accepts the following parameters:

=over

=item ColorScheme

One of the color schemes accepted by C<Graphics::ColorNames>,
which is used to interpret color names on input. Valid values
include C<X> (color names used in X-Windows) and C<HTML> (color
names defined in the HTML 4.0 specification). For a full list of
possible values, please refer to the documentation of of
C<Graphics::ColorNames>.

Default: C<X> (Note: This is incompatible with HTML color names).

=item OutputFormat

One of the output formats defined by this module. Possible values are:

=over

=item tuple

Returns a list of three values in the range 0..255. The first value is
guaranteed to have a C<length> that is not a multiple of three.

=item hex

Returns a hexadecimal RGB value as a string in the format RRGGBB.

=item html

Returns a string compatible with W3C's HTML and CSS specifications,
i.e. I<#RRGGBB> or one of the sixteen HTML color names.

=item obj
	
Returns a C<Color::Object> reference. The module
C<Color::Object> must be installed, of course.

=item object

Returns a C<Graphics::ColorObject> reference. The module
C<Graphics::ColorObject> must be installed, of course.

=item pdf

Returns a string compatible with C<PDF::API2>, i.e. I<#RRGGBB>.

=item __MODEvar

(DEPRECATED) Uses the value of C<$Color::Calc::MODE> to select one
of the above output formats. You should use C<local> when setting
this variable:

  local $Color::Calc::MODE = 'html';

=back

Default: C<__MODEvar> (for compatibility)

=back

=item Color::Calc->import( ... )

This method creates a new, hidden object and binds its methods to the namespace
of the calling module.

This method is usually not called directly but from perl's C<use> statement:

  use Color::Calc(
    'ColorScheme' => 'X',
    'OutputFormat' => 'HTML',
    'Prefix' => 'cc' );
  print cc_invert( 'white' );	# prints 'black'

On import, you can specify the following parameters:

=over

=item ColorScheme

See above.

=item OutputFormat

See above.

=item Prefix

Adds a prefix to the front of the method names. The calculation methods are
bound to the name  I<prefix>_I<method_name> (the specified prefix, an
underscore, the calculation method's name). Further, I<prefix> is made an alias
for I<prefix>C<_get>.

Default: C<color>

=back

Please note that with perl's C<use> and C<import> statemehts, omitting the list
and specifying an empty list has different meanings:

  use Color::Calc;	# import with default settings (see below)

  use Color::Calc();	# don't import anything

=back

=head3 Property "set"/"get" methods

These methods are inaccessible without a object reference, i.e. when the
functions have been C<import>ed.

=over

=item $cc->set_output_format( $format)

Changes the output format for an existing C<Color::Calc> object.  

=back

=head3 Calculation methods

All calculation methods I<always> accept the following formats for C<$color> or
C<$color1>/C<$color2>:

=over

=item * 

An arrayref pointing to an array with three elements in the range
C<0>..C<255> corresponding to the red, green, and blue component.

=item *

A list of three values in the range C<0>..C<255> corresponding to the red,
green, and blue component where the first value does not have 3 or a multiple
of 3 digits (e.g. C<('0128',128,128)>).

=item * 

A string containing a hexadecimal RGB value like
C<#I<RGB>>/C<#I<RRGGBB>>/C<#I<RRRGGGBBB>>/..., or
C<I<RGB>>/C<I<RRGGBB>>/C<I<RRRGGGBBB>>/...

=item *

A color name accepted by C<Graphics::ColorNames>. The
interpretation is controlled by the C<ColorScheme> parameter.

=item *

A C<Graphics::ColorObject> reference.

=back

The calculation methods can be either accessed through a C<Color::Calc> object
reference (here: C<$cc>) or through the method names imported by C<import>
(here using the prefix L<color>).

=over

=item $cc->get($color) / color($color)

Returns C<$color> as-is (but in the selected output format). This
function can be used for color format conversion/normalisation.

=item $cc->invert($color) / color_invert($color)

Returns the inverse of C<$color>.

=item $cc->bw($color) / color_bw($color)

=item $cc->grey($color) / color_grey($color)

=item $cc->gray($color) / color_gray($color)

Converts C<$color> to greyscale.

=item $cc->mix($color1, $color2 [, $alpha]) / color_mix($color1, $color2 [, $alpha])

Returns a color that is the mixture of C<$color1> and C<$color2>.

The optional C<$alpha> parameter can be a value between 0.0 (use
C<$color1> only) and 1.0 (use C<$color2> only), the default is 0.5.

=item $cc->light($color [, $alpha]) / color_light($color [, $alpha])

Returns a lighter version of C<$color>, i.e. returns
C<mix($color,[255,255,255],$alpha)>.

The optional C<$alpha> parameter can be a value between 0.0 (use C<$color>
only) and 1.0 (use [255,255,255] only), the default is 0.5.

=item $cc->dark($color [, $alpha]) / color_dark($color [, $alpha])

Returns a darker version of C<$color>, i.e. returns
C<mix($color,[0,0,0],$alpha)>.

The optional C<$alpha> parameter can be a value between 0.0 (use
C<$color> only) and 1.0 (use [0,0,0] only), the default is 0.5.

=item $cc->contrast($color [, $cut]) / color_contrast($color [, $cut])

Returns a color that has the highest possible contrast to the input
color.

This is done by setting the red, green, and blue values to 0 if
the corresponding value in the input is above C<($cut * 255)> and
to 255 otherwise.

The default for C<$cut> is .5, representing a cutoff between 127 and 128.

=item $cc->contrast_bw($color [, $cut]) / color_contrast_bw($color [, $cut])

Returns black or white, whichever has the higher contrast to C<$color>.

This is done by returning black if the grey value of C<$color> is
above C<($cut * 255)> and white otherwise.

The default for C<$cut> is .5, representing a cutoff between 127 and 128.

=item $cc->blend($color [, $alpha])
color_blend($color [, $alpha])

Returns a color that blends into the background, i.e. it returns
C<mix($color,contrast($color),$alpha)>.

The optional C<$alpha> parameter can be a value between 0.0 (use
C<$color> only) and 1.0 (use C<contrast($color)> only), the
default is 0.5.

The idea is that C<$color> is the foreground color, so
C<contrast($color)> is similar to the background color. Mixing
them returns a color somewhere between them.

You might want to use C<mix($color, $background, $alpha)> instead
if you know the real background color.

=item $cc->blend_bw($color [, $alpha]) / color_blend_bw($color [, $alpha])

Returns a mix of C<$color> and black or white, whichever has the
higher contrast to C<$color>.

The optional C<$alpha> parameter can be a value between 0.0 (use
C<$color> only) and 1.0 (use black/white only), the default is 0.5.

=back

=head3 Functions

The calculation methods are also available as functions. The output format is
selected through the function name.

These functions are deprecated as they do not allow selecting the scheme of
recognized color names, which defaults to L<Graphics::ColorNames::X> (and is
incompatible with HTML's color names).

By default, i.e. when no list is specified with C<use> or C<import>, all of
these functions are exported.

=over

=item color, color_mix, ...

Use C<$Color::Calc::MODE> as the output format. This is the default.

=item color_hex, color_mix_html, ...

Use C<hex> as the output format.

=item color_html, color_mix_html, ...

Use C<html> as the output format. Please note that the color names recognized
are still based on X's color names, which are incompatible with HTML. You can't
use the output of these functions as input for other color_*_html functions.

See L<Color::Calc::WWW> for an alternative that does not suffer from this
problem.

=item color_pdf, color_mix_pdf, ...

Use C<pdf> as the output format.

=item color_object, color_mix_object, ...

Use C<object> as the output format.

=back

=head1 SEE ALSO

L<Graphics::ColorNames> (required); L<Graphics::ColorObject> (optional)

=head1 AUTHOR

Claus FE<auml>rber <CFAERBER@cpan.org>

=head1 LICENSE

Copyright 2004-2009 Claus FE<auml>rber. All rights reserved.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
