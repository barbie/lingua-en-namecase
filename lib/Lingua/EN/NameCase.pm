package Lingua::EN::NameCase ;

use strict ;
use locale ;

use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK $SPANISH ) ;

$VERSION = '1.15' ;

#--------------------------------------------------------------------------
# Modules

use Carp ;
use Exporter() ;

@ISA        = qw( Exporter ) ;
@EXPORT     = qw( nc ) ;
@EXPORT_OK  = qw( NameCase nc ) ;

#--------------------------------------------------------------------------
# Variables

$SPANISH    = 0;

#--------------------------------------------------------------------------
# Functions

sub NameCase {

    croak "Usage: \$SCALAR|\@ARRAY = NameCase [\\]\$SCALAR|\@ARRAY"
        if ref $_[0] and ( ref $_[0] ne 'ARRAY' and ref $_[0] ne 'SCALAR' ) ;
        
    local( $_ ) ;

    if( wantarray and ( scalar @_ > 1 or ref $_[0] eq 'ARRAY' ) ) {
        # We have received an array or array reference in a list context
        # so we will return an array.
        map { nc( $_ ) } @{ ref( $_[0] ) ? $_[0] : \@_ } ;
    } 
    elsif( ref $_[0] eq 'ARRAY' ) {
        # We have received an array reference in a scalar or void context
        # so we will work on the array in-place.
        foreach ( @{ $_[0] } ) { 
            $_ = nc( $_ ) ;
        }
    }
    elsif( ref $_[0] eq 'SCALAR' ) {
        # We don't work on scalar references in-place; we take the value 
        # and return a name-cased copy.
        nc( ${ $_[0] } ) ;
    }
    elsif( scalar @_ == 1 and not ref $_[0] ) {
        # We've received a scalar: we return a name-cased copy.
        nc( $_[0] ) ;
    }
    else {
        croak "NameCase only accepts a single scalar, array or array ref" ;
    }
}

sub nc {

    croak "Usage: nc [[\\]\$SCALAR]"
        if scalar @_ > 1 or ( ref $_[0] and ref $_[0] ne 'SCALAR' ) ;
        
    local( $_ ) = @_ if @_ ;
    $_ = ${$_} if ref( $_ ) ;           # Replace reference with value.

    $_ = lc ;                           # Lowercase the lot.
    s{ \b (\w)   }{\u$1}gox ;           # Uppercase first letter of every word.
    s{ (\'\w) \b }{\L$1}gox ;           # Lowercase 's.

    # Name case Mcs and Macs - taken straight from NameParse.pm incl. comments.
    # Exclude names with 1-2 letters after prefix like Mack, Macky, Mace
    # Exclude names ending in a,c,i,o, or j are typically Polish or Italian

    if ( /\bMac[A-Za-z]{2,}[^aciozj]\b/o or /\bMc/o ) {
        s/\b(Ma?c)([A-Za-z]+)/$1\u$2/go ;

        # Now correct for "Mac" exceptions
        s/\bMacEvicius/Macevicius/go ;  # Lithuanian
        s/\bMacHado/Machado/go ;        # Portuguese
        s/\bMacHar/Machar/go ;
        s/\bMacHin/Machin/go ;
        s/\bMacHlin/Machlin/go ;
        s/\bMacIas/Macias/go ;  
        s/\bMacIulis/Maciulis/go ;  
        s/\bMacKie/Mackie/go ;
        s/\bMacKle/Mackle/go ;
        s/\bMacKlin/Macklin/go ;
        s/\bMacQuarie/Macquarie/go ;
        s/\bMacOmber/Macomber/go ;
        s/\bMacIn/Macin/go ;
        s/\bMacKintosh/Mackintosh/go ;
        s/\bMacKen/Macken/go ;
        s/\bMacHen/Machen/go ;
        s/\bMacisaac/MacIsaac/go ;
        s/\bMacHiel/Machiel/go ;
        s/\bMacIol/Maciol/go ;
        s/\bMacKell/Mackell/go ;
        s/\bMacKlem/Macklem/go ;
        s/\bMacKrell/Mackrell/go ;
        s/\bMacLin/Maclin/go ;
        s/\bMacKey/Mackey/go ;
        s/\bMacKley/Mackley/go ;
        s/\bMacHell/Machell/go ;
        s/\bMacHon/Machon/go ;
    }
    s/Macmurdo/MacMurdo/go ;
 
    # Fixes for "son (daughter) of" etc. in various languages.
    s{ \b Al(?=\s+\w)  }{al}gox ;                   # al Arabic or forename Al.
    s{ \b Ap        \b }{ap}gox ;                   # ap Welsh.
    s{ \b Ben(?=\s+\w) }{ben}gox ;                  # ben Hebrew or forename Ben.
    s{ \b Dell([ae])\b }{dell$1}gox ;               # della and delle Italian.
    s{ \b D([aeiu]) \b }{d$1}gox ;                  # da, de, di Italian; du French.
    s{ \b De([lr])  \b }{de$1}gox ;                 # del Italian; der Dutch/Flemish.
    s{ \b El        \b }{el}gox unless $SPANISH ;   # el Greek or El Spanish.
    s{ \b La        \b }{la}gox unless $SPANISH ;   # la French or La Spanish.
    s{ \b L([eo])   \b }{l$1}gox ;                  # lo Italian; le French.
    s{ \b Van(?=\s+\w) }{van}gox ;                  # van German or forename Van.
    s{ \b Von       \b }{von}gox ;                  # von Dutch/Flemish

    # Fixes for roman numeral names, e.g. Henry VIII, up to 89, LXXXIX
    s{ \b ( (?: [Xx]{1,3} | [Xx][Ll]   | [Ll][Xx]{0,3} )?
            (?: [Ii]{1,3} | [Ii][VvXx] | [Vv][Ii]{0,3} )? ) \b }{\U$1}gox ;

    $_ ;
}

1 ;

__END__

#--------------------------------------------------------------------------

=head1 NAME

Lingua::EN::NameCase - Correctly case a person's name from UPERCASE or lowcase

=head1 SYNOPSIS

    # Working with scalars; complementing lc and uc.

    use Lingua::EN::NameCase qw( nc ) ;

    $FixedCasedName  = nc( $OriginalName ) ;

    $FixedCasedName  = nc( \$OriginalName ) ;

    # Working with arrays or array references.

    use Lingua::EN::NameCase 'NameCase' ;

    $FixedCasedName  = NameCase( $OriginalName ) ;
    @FixedCasedNames = NameCase( @OriginalNames ) ;

    $FixedCasedName  = NameCase( \$OriginalName ) ;
    @FixedCasedNames = NameCase( \@OriginalNames ) ;

    NameCase( \@OriginalNames ) ; # In-place.

    # NameCase will not change a scalar in-place, i.e.
    NameCase( \$OriginalName ) ; # WRONG: null operation.

    $Lingua::EN::NameCase::SPANISH = 1;
    # Now 'El' => 'El' instead of (default) Greek 'El' => 'el'.
    # Now 'La' => 'La' instead of (default) French 'La' => 'la'.

=head1 DESCRIPTION

Forenames and surnames are often stored either wholly in UPPERCASE
or wholly in lowercase. This module allows you to convert names into
the correct case where possible.

Although forenames and surnames are normally stored separately if they
do appear in a single string, whitespace separated, NameCase and nc deal
correctly with them.

NameCase currently correctly name cases names which include any of the
following:

    Mc, Mac, al, el, ap, da, de, delle, della, di, du, del, der, 
    la, le, lo, van and von.

It correctly deals with names which contain apostrophies and hyphens too.

=head2 EXAMPLE FIXES

    Original            Name Case
    --------            ---------
    KEITH               Keith
    LEIGH-WILLIAMS      Leigh-Williams
    MCCARTHY            McCarthy
    O'CALLAGHAN         O'Callaghan
    ST. JOHN            St. John

plus "son (daughter) of" etc. in various languages, e.g.:

    VON STREIT          von Streit
    VAN DYKE            van Dyke
    AP LLWYD DAFYDD     ap Llwyd Dafydd
    etc.

plus names with roman numerals (up to 89, LXXXIX), e.g.:

    henry viii          Henry VIII
    louis xiv           Louis XIV

=head1 BUGS

The module covers the rules that I know of. There are probably a lot
more rules, exceptions etc. for "Western"-style languages which could be
incorporated.

There are probably lots of exceptions and problems - but as a general
data 'cleaner' it may be all you need.

Use Kim Ryan's NameParse.pm for any really sophisticated name parsing.

=head1 AUTHOR

  1998-2014    Mark Summerfield <summer@qtrac.eu>
  2014-present Barbie <barbie@cpan.org>  

=head1 ACKNOWLEDGEMENTS

Thanks to Kim Ryan <kimaryan@ozemail.com.au> for his Mc/Mac solution.

=head1 COPYRIGHT

Copyright (c) Mark Summerfield 1998-2014. All Rights Reserved.
Copyright (c) Barbie 2014. All Rights Reserved.

This distribution is free software; you can redistribute it and/or
modify it under the Artistic Licence v2.

=cut
