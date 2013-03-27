use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'SQL::Easy',
    "test" => {
        "TESTS" => "t/*.t"
    },
);
