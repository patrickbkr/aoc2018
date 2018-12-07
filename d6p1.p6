#!/usr/bin/env perl6

sub m-dist($x1, $y1, $x2, $y2) {
    abs($x2-$x1) + abs($y2-$y1)
}

my @input = 'input-d6.txt'.IO.lines.map: { .split(', ').map(*.Int) };

my ($xs = 100000, $xb = 0, $ys = 100000, $yb = 0);

for @input {
    $xs = min(@_[0][0], $xs);
    $xb = max(@_[0][0], $xb);
    $ys = min(@_[0][1], $ys);
    $yb = max(@_[0][1], $yb);
}

my @map;
@map[$_] = 0 xx $yb for 0..$xb-1;

for 0 ..^ $xb -> $x {
    for 0 ..^ $yb -> $y {
        my $min-dist = 10000;
        my $p;
        for @input -> $point {
            my $dist = m-dist($x, $y, $point[0], $point[1]);
            if $dist < $min-dist {
                $min-dist = $dist;
                $p = $point;
            }
        }
        say $min-dist;
        say $p;
        say "$x x $y";
        @map[$x,$y] = $p;
    }
}

say @map;
