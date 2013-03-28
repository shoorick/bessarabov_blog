use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'SQL::Easy',
    PREREQ_PM => {
        'Test::More' => 0,
        'Test::Whitespaces' => 0,
    },
    "test" => {
        "TESTS" => "t/*.t"
    },
);
