#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use DDP;    # TODO bes
use Carp;

use Text::Aspell;
use File::Slurp;
use Test::More;

# global vars
my $true = 1;
my $false = '';

# subs

# main
sub main {

    ok($true, 'Loaded ok');

    my $speller = Text::Aspell->new();
    $speller->set_option('lang','ru_RU');

    my @files = glob("posts/*_ru");

    foreach my $file (@files) {
        my $content = read_file($file);
        my @words = split(/\s+/, $content);

        foreach my $word (@words) {

            print $speller->check( $word )
                ? '' # "$word - found\n"
                : "$word - not found!\n"
                ;
        }

    }

    done_testing();
    print "#END\n";
}

main();
__END__
~
