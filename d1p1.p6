#!/usr/bin/env perl6

my $a=0;
for 'input-day1-p1.txt'.IO.lines {
    if $_.starts-with('+') {
        $a += $_.substr(1)
    } else {
        $a -= $_.substr(1)
    }
};
say $a

