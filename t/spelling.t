#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use Carp;

use utf8;
use Text::Aspell;
use File::Slurp;
use Test::More;

# global vars
my $true = 1;
my $false = '';

# subs
sub get_content {
    my ($file) = @_;

    my @lines = read_file($file, binmode => ':utf8');
    my @lines_with_text;

    foreach my $line (@lines) {
        chomp $line;
        next if $line =~ /^ \[/;
        next if $line =~ /^    /;
        next if $line =~ /^date_time:/;

        push @lines_with_text, $line;
    }

    my $content = join "\n", @lines_with_text;

    # Remove markdown links: [some text][link]
    # There is a loop here to remove all nested links like:
    # [![Some description][link1]][link2]

    my $result = $true;
    while ($result) {
        $result = (
            $content =~ s/
                !?
                \[
                    ( [^\[\]]+ )
                \]

                \[
                    ( [^\[\]]+ )
                \]
            /$1/gx
        );
    }

    return $content;
}

# main
sub main {

    binmode Test::More->builder->output, ":utf8";
    binmode Test::More->builder->failure_output, ":utf8";

    pass('Loaded ok');

    my $speller = Text::Aspell->new();
    $speller->set_option('lang','ru_RU');

    my @files = glob("posts/*_ru");

    my @errors;

    foreach my $file (@files) {
        my $content = get_content($file);

        my @words = split(/\s+/, $content);

        foreach my $word (@words) {
            $word =~ s/[«»"():,\.!\?]//g;
            next if $word =~ /^[\d\.:-]+$/;
            next if $word =~ /^[#—-]+$/;

            if ($speller->check($word)) {
            } else {
                push(@errors, $word);
            }

        }
    }

    my $test_name = "Blog posts has no unknown words";

    if (!@errors) {
        pass($test_name);
    } else {
        my $errors_text = " * ";
        $errors_text .= join("\n * ", @errors) . "\n";

        fail($test_name);
        diag($errors_text);
        diag("-"x30);
        diag("Total unknown words: " . scalar @errors);
    }

    done_testing();
    print "#END\n";
}

main();
__END__
~
