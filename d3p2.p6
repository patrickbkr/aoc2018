#!/usr/bin/env perl6

my @a[1001;1001];
for 0 ..^ 1001 -> $x {
    for 0 ..^ 1001 -> $y {
        @a[$x;$y] = 0;
    }
}

my %e;

for 'input-d3p1.txt'.IO.lines {
    if $_ ~~ / \# (\d+) <ws> \@ <ws> (\d+) \, (\d+) \: <ws> (\d+) x (\d+) / {
        my $id = $0.Int;
        my $xs = $1.Int;
        my $ys = $2.Int;
        my $xd = $3.Int;
        my $yd = $4.Int;

        %e{$id} = 0;
        loop (my $x = $xs; $x < $xs + $xd; $x++) {
            loop (my $y = $ys; $y < $ys + $yd; $y++) {
                if @a[$x;$y] > 0 {
                    %e{@a[$x;$y]}++;
                    %e{$id}++;
                }
                else {
                    @a[$x;$y] = $id;
                }
            }
        }
    }
}

for %e.kv -> $k, $v {
    say $k if $v == 0
}
