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

my %counts;
my SetHash $infinites .= new;

for $xs .. $xb -> $x {
    for $ys .. $yb -> $y {
        my $min-dist = 10000;
        my Int $p;
        for @input.kv -> $counter, $point {
            my $dist = m-dist($x, $y, $point[0], $point[1]);
            if $dist < $min-dist {
                $min-dist = $dist;
                $p = $counter;
            }
            elsif $dist == $min-dist {
                $p = -1;
            }
        }

        if $p != -1 {
            %counts{$p}++;
            if $x == $xs || $y == $ys || $x == $xb || $y == $yb {
                $infinites{$p}++;
            }
        }
    }
}

my $max = 0;
for %counts.kv -> $k, $v {
    if !$infinites{+$k} {
        $max = max($max, $v);
    }
}

say $max;
