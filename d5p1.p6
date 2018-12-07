#!/usr/bin/env perl6

my @p = 'input-d5.txt'.IO.slurp.trim.split: '', :skip-empty;

sub collapsed-length(@pa) {
    my @p = @pa;
    my $l = 0;
    my $r = 1;
    while True {
        if @p[$l].lc eq @p[$r].lc && @p[$l] ne @p[$r] {
            @p.splice: $l, 2;
            $l -= 1 if $l > 0;
            $r -= 1 if $r > 1;
        }
        else {
            $l++;
            $r++;
        }
        last if $r >= +@p;
    }
    +@p
}

say "part 1: " ~ collapsed-length @p;

{ # part 2
    my $char;
    my $elems = +@p;
    for 'a' .. 'z' -> $bad {
        my $l = collapsed-length( @p.grep: { $_.lc ne $bad } );
        if $l < $elems {
            $elems = $l;
            $char = $bad;
        }
    }
    
    say "part2: $char $elems";
}

