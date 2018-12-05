#!/usr/bin/env perl6

sub diff(@a, @b) {
    return False if @a.elems != @b.elems;

    my $d=0;
    loop (my $c=0;$c < @a.elems; $c++) {
        $d++ if @a[$c] ne @b[$c]
    }
    return $d == 1;
}

my @a;
for 'input-d2p1.txt'.IO.lines {
    @a.push: $_.split('', :skip-empty);
}

loop (my $c=0; $c < @a.elems - 1; $c++) {
    loop (my $d=$c+1; $d < @a.elems; $d++) {
        if diff(@a[$c], @a[$d]) {
            my $r;
            loop (my $x=0;$x < @a[$c].elems;$x++) {
                $r ~= @a[$c][$x] if @a[$c][$x] eq @a[$d][$x];
            }
            say $r;
            say @a[$c];
            say @a[$d];
            exit
        }
    }
}

