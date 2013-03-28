use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'SQL::Easy',
    PREREQ_PM => {
        'File::Slurp' => 0,
        'Test::More' => 0,
        'Test::Whitespaces' => 0,
        'Text::Aspell' => 0,
    },
    "test" => {
        "TESTS" => "t/*.t"
    },
);
