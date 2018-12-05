#!/usr/bin/env perl6

my $a = 0;
my %f;
while True {
    for './input-day1-p1.txt'.IO.lines {
        if %f{$a}:exists {
            say $a;
            exit
        }
        %f{$a}++;

        if $_.starts-with('+') {
            $a += $_.substr(1)
        } else {
            $a -= $_.substr(1)
        }
    }
}

