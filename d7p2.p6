#!/usr/bin/env perl6

my $workers = 5;

class Node {
    has $.name;
    has $.duration is rw; 
    has @.dependents;
    has @.dependencies;
}

my Node %nodes;

for 'input-d7.txt'.IO.lines {
    if /"Step " (.) " must be finished before step " (.) " can begin."/ {
        %nodes{$0} //= Node.new: name => $0, duration => 60 + $0.ord - 'A'.ord + 1;
        %nodes{$1} //= Node.new: name => $1, duration => 60 + $1.ord - 'A'.ord + 1;
        
        %nodes{$0}.dependents.push: $1;
        %nodes{$1}.dependencies.push: $0;
    }
    else {
        say "Failure: $_";
    }
}

for %nodes.values {
    say $^n.name ~ '(' ~ $^n.duration ~ ') <-- ' ~ $^n.dependencies.join: ', ';
}

my @result;
my @availables;
my @in-progress;
my $seconds = 0;

while True {
    for %nodes.kv -> $k, $n {
        if +$n.dependencies == 0 {
            @availables.push: $n;
            %nodes{$n.name}:delete;
        }
    }

    last if !@availables && !@in-progress;

    while +@in-progress < $workers && @availables {
        my $candidate;
        for @availables -> $n {
            $candidate = $n if !$candidate || $n.name lt $candidate.name;
        }

        @in-progress.push: $candidate;
        @availables .= grep: {$_ !=== $candidate};
    }

    for @in-progress -> $n {
        $n.duration--;
        if $n.duration == 0 {
            @result.push: $n.name;
            @in-progress .= grep: {$_ !=== $n};
            for %nodes.values -> $n2 {
                $n2.dependencies .= grep: { $_ ne $n.name };
            }
        }
    }

    $seconds++;
}

say "Result: " ~ @result.join: '';
say $seconds;
