package Algorithm::PermuteInPlace;

require 5.005;
use strict;

require Exporter;
use vars qw(@ISA $VERSION);

@ISA = qw(Exporter);
BEGIN {
    $VERSION = 0.02;
}

use Inline Config=>
     NAME    => __PACKAGE__,
     VERSION => $VERSION;

use Inline C => <<'END_C';

typedef struct {
    AV*   array;
    I32   len;
    I32*  p;
    I8*   d;
} Permutor;

SV* new(char* class, SV* array_sv) {
    Permutor* self       = (Permutor*)malloc(sizeof(Permutor));
    SV*       selfref_sv = newSV(0);
    SV*       self_sv    = newSVrv(selfref_sv, class);
    I32       i;
    AV*       array;
    
    if (!SvROK(array_sv)    || SvTYPE(SvRV(array_sv)) != SVt_PVAV)
        Perl_croak(aTHX_ "Array is not an ARRAY reference");
    array    = (AV*)SvRV(array_sv);
    
    if (SvREADONLY(array))
        Perl_croak(aTHX_ "Array is read-only");
    
    sv_setiv(self_sv, (IV)self);
    SvREADONLY_on(self_sv);
    
    self->array = (AV*) SvREFCNT_inc(array);
    self->len   = av_len(array);
    self->p     = (I32*)malloc((1+self->len) * sizeof(I32));
    self->d     = (I8*) malloc((1+self->len) * sizeof(I8));
    
    for (i=0; i <= self->len; ++i) {
        (self->d)[i] = (I8) -1;
        (self->p)[i] = (I32) i;
    }
    
    return selfref_sv;
}

bool next(SV* self_sv) {
    Permutor* self = (Permutor*)SvIV(SvRV(self_sv));
    SV*  tmp;
    SV** arr = AvARRAY(self->array);
    
    I32 l  = 0;
    I32 i  = self->len;
    I32* p = self->p;
    I8*  d = self->d;
    
    I32 x, y;
    
    if (av_len(self->array) != self->len)
        Perl_croak(aTHX_ "Length of array has changed");
    
    while (i > 0 && ((p[i] == 0 && d[i] < 0) || (p[i] == i && d[i] > 0)) ) {
        if (p[i] == 0) ++l;
        d[i] = -d[i];
	--i;
    }
    if (i == 0) {
        if (self->len > 1) {
            tmp = arr[0]; arr[0] = arr[1]; arr[1] = tmp;
        }
        return FALSE;
    }

    x = p[i]+l;  y = x + d[i];
    p[i] += d[i];

    tmp = arr[x]; arr[x] = arr[y]; arr[y] = tmp;

    return TRUE;
}

void DESTROY(SV* self_sv) {
    Permutor* self = (Permutor*)SvIV(SvRV(self_sv));
    free(self->p);
    free(self->d);
    free(self);
}


END_C

1;
__END__

=head1 NAME

Algorithm::PermuteInPlace - Fast permutations

=head1 SYNOPSIS

  use Algorithm::PermuteInPlace;
  my @array = (1..9);
  my $permutor = Algorithm::PermuteInPlace->new(\@array);
  print "@array\n";
  print "@array\n" while $permutor->next();

=head1 DESCRIPTION

This module will generate all the permutations of an array, modifying the
array in-place.  That allows it to be very fast.

Each time you call C<$p-E<gt>next()>, two adjacent elements of the array are swapped.
This is done in such a way that every permutation will eventually be generated.
When the last permutation has been generated (so that the list has been restored
to its original order), C<next> returns false.

It's not recommended to change the elements of the array while a permutor is
attached to it. If the length changes, C<next()> will die.

Algorithm::PermuteInPlace currently uses the so-called I<Johnson-Trotter algorithm>.
This may change, if a different algorithm proves to be faster.

=head1 AUTHOR

Robin Houston, <robin@cpan.org>

=head1 SEE ALSO

L<Algorithm::Permute>, L<List::Permutor>, L<perlfaq4>

=cut
