#!/usr/bin/env perl6

my ($c2, $c3);
for 'input-d2p1.txt'.IO.lines {
    my %c;
    %c{$_}++ for $_.split('',:skip-empty);

    for %c.values.unique {
        $c2++ if $_ == 2;
        $c3++ if $_ == 3;
    }
}
say $c2 * $c3;
