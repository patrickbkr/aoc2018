#!/usr/bin/env perl6

# parse the logs
my @logs;
for 'input-d4p1.txt'.IO.lines {
    die unless / \[ ( \d+ \- \d+ \- \d+ ) \s ( \d+ \: ( \d+ ) ) \] \s ( "falls asleep" | "wakes up" | "Guard #" (\d+) " begins shift" ) /;
    @logs.push: {
        date  => $0.Str,
        time  => $1.Str,
        min   => $1[0].Int,
        state => $2.Str,
        guard => $2[0] ?? $2[0].Int !! '',
    };
}

# Sum up the sleep times.
my %guards; {
    @logs.=sort: { ($^a<date> ~ $^a<time>) cmp ($^b<date> ~ $^b<time>) };
    my $gid;
    for @logs {
        if $_<guard> {
            $gid = $_<guard>;
        }
        else {
            %guards{$gid} = {mins => [0 xx 60], sleeping => False} if !%guards{$gid};
            my %guard := %guards{$gid};
            if !%guard<sleeping> && $_<state> eq 'falls asleep' {
                %guard<sleeping> = True;
                %guard<sleep-start> = $_<min>;
            }
            elsif %guard<sleeping> && $_<state> eq 'wakes up' {
                %guard<mins>[$_]++ for %guard<sleep-start> ..^ $_<min>;
                %guard<sleep-time> += $_<min> - %guard<sleep-start>;
                %guard<sleeping> = False;
            }
            else { die %guard.gist ~ " {$_.gist}" }
        }
    }
}

{ # Part 1
    # Find the longest sleeper ...
    my $gid; {
        my $sleep-time = 0;
        for %guards.kv -> $k, $v {
            if $v<sleep-time> > $sleep-time {
                $gid = $k;
                $sleep-time = $v<sleep-time>;
            }
        }
    }

    say "Longest sleeper: $gid";

    # ... and the longest sleep minute.
    my $minute; {
        my $sleep-time = 0;
        for %guards{$gid}<mins>.kv -> $k, $v {
            if $v > $sleep-time {
                $minute = $k;
                $sleep-time = $v;
            }
        }
    }

    say "Longest sleep minute: $minute";

    say "Part1: solution = {$gid * $minute}";
}

{ # ... part 2: find the guard with the longest sleep minute.
    my ($gid, $minute, $sleep-time = 0); {
        for %guards.kv -> $igid, $v {
            for $v<mins>.kv -> $min, $s {
                if $s > $sleep-time {
                    $gid = $igid;
                    $minute = $min;
                    $sleep-time = $s;
                }
            }
        }
    }

    say "Part2: guard = $gid, min = $minute, solution = {$gid * $minute}";
}

