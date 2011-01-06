use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Parallel::Simple::Dynamic',
    AUTHOR              => q{Aleksandra Markovets <marsa@cpan.org>},
    VERSION_FROM        => 'lib/Parallel/Simple/Dynamic.pm',
    ABSTRACT_FROM       => 'lib/Parallel/Simple/Dynamic.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Parallel-Simple-Dynamic-*' },
);
