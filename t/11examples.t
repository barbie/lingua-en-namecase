#!/usr/bin/perl
use strict;

use Lingua::EN::NameCase 'nc';
use Test::More  tests => 11;

my %tests = (
    q{DR SARAH BEETLE}              => q{Dr Sarah Beetle},
    q{june O'LEARY}                 => q{June O'Leary},
    q{MICHAEL JOHN JACOBS JR}       => q{Michael John Jacobs Jr},
    q{MR. jon whitacre iii}         => q{Mr. Jon Whitacre III},
    q{MARY BETH DAVIDSON MD}        => q{Mary Beth Davidson MD},
    q{MS LAURA CONLEY-ROSE}         => q{Ms Laura Conley-Rose},
    q{LAURA&DAVID SMITH}            => q{Laura&David Smith},
    q{ESTATE OF LAURA JONES}        => q{Estate Of Laura Jones},
    q{MS MS. LAURA J BYRD}          => q{Ms Ms. Laura J Byrd},
    q{ben mcgrath}                  => q{Ben McGrath},
    q{Aharon ben Amram ha-Kohein}   => q{Aharon ben Amram Ha-Kohein},
);

for my $test (keys %tests) {
    is( nc($test), $tests{$test});
}
