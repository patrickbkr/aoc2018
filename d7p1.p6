#!/usr/bin/env perl6

class Node {
    has $.name;
    has @.dependents;
    has @.dependencies;
}

my Node %nodes;

for 'input-d7.txt'.IO.lines {
    if /"Step " (.) " must be finished before step " (.) " can begin."/ {
        %nodes{$0} //= Node.new: name => $0;
        %nodes{$1} //= Node.new: name => $1;
        
        %nodes{$0}.dependents.push: $1;
        %nodes{$1}.dependencies.push: $0;
    }
    else {
        say "Failure: $_";
    }
}

for %nodes.values {
    say $^n.name ~ ' <-- ' ~ $^n.dependencies.join(', ') ~ '  --> ' ~ $^n.dependents.join(', ');
}

my @result;
my @availables;

while True {
    for %nodes.kv -> $k, $n {
        if +$n.dependencies == 0 {
            @availables.push: $n;
        }
    }

    last if !@availables;

    my $candidate;
    for @availables -> $n {
        $candidate = $n if !$candidate || $n.name lt $candidate.name;
    }
    @result.push: $candidate.name;
    @availables .= grep: {$_ !=== $candidate};
    for %nodes.values -> $n {
        $n.dependencies .= grep: { $_ ne $candidate.name };
    }
    %nodes{$candidate.name}:delete;
}

say "Result: " ~ @result.join: '';

for %nodes.values {
    say $^n.name ~ ' <-- ' ~ $^n.dependencies.join(', ') ~ '  --> ' ~ $^n.dependents.join(', ');
}

