use ExtUtils::MakeMaker ;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'         => 'Lingua::EN::NameCase',
    'VERSION_FROM' => 'NameCase.pm', # finds $VERSION
    'DISTNAME'     => 'Lingua-EN-NameCase',
    ($] >= 5.005 ?
        (
            ABSTRACT => 'Change UCASE and lowcase names to Proper Case',
            AUTHOR   => 'Mark Summerfield <summer@chest.ac.uk>',
        ) : () ),
    'LIBS'         => [''],   # e.g., '-lm'
    'DEFINE'       => '',     # e.g., '-DHAVE_SOMETHING'
    'INC'          => '',     # e.g., '-I/usr/include/other'
    'dist'         => { COMPRESS => "gzip -9", SUFFIX => "gz" }
) ;
