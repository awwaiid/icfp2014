#!/usr/bin/env perl

use strict;

my @proggie;
my %label;

while(my $line = <>) {
  chomp $line;
  $line =~ s/^\s+//;
  $line =~ s/\s*;.*$//;
  next if $line eq '';
  if($line =~ /^([\w_]+):$/) {
    $label{$1} = scalar @proggie;
  } else {
    push @proggie, $line;
  }
}

@proggie = map {
  my $line = $_;
  foreach my $label (keys %label) {
    my $linenum = $label{$label};
    $line =~ s/\b$label\b/$linenum/g;
  }
  $line
} @proggie;

print join("\n", @proggie);
print "\n";

