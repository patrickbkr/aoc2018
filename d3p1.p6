#!/usr/bin/env perl6

my @a[1001;1001];
for 0 ..^ 1001 -> $x {
    for 0 ..^ 1001 -> $y {
        @a[$x;$y] = 0;
    }
}

for 'input-d3p1.txt'.IO.lines {
    if $_ ~~ / \# (\d+) <ws> \@ <ws> (\d+) \, (\d+) \: <ws> (\d+) x (\d+) / {
        my $xs = $1.Int;
        my $ys = $2.Int;
        my $xd = $3.Int;
        my $yd = $4.Int;
        loop (my $x = $xs; $x < $xs + $xd; $x++) {
            loop (my $y = $ys; $y < $ys + $yd; $y++) {
                @a[$x;$y]++;
            }
        }
    }
}

my $c = 0;
for @a -> $r {
    for $r -> $t {
        $c++ if $t >= 2
    }
}
say $c;
