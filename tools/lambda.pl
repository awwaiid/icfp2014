#!/usr/bin/env perl

use strict;

my $functions = {};

sub def {
  my ($fname, $args, $body) = @_;
  print "$fname:\n";
  foreach my $n (0..@$args-1) {
    print "\$functions->{$fname}{$args->[$n]} = $n;\n";
    $functions->{$fname}{$args->[$n]} = $n;
  }
  sexp($fname, $body) if $body;
  print "RTN\n";
}

# Translate an sexp to code, result on stack
sub sexp {
  my ($fname, $body) = @_;

  if(ref $body eq 'ARRAY') {
    my ($func, @args) = @$body;
 
    # First we evaluate the parameters, they go on the stack
    map { sexp($fname, $_) } @args; # evaluate each arg and put them on the stack

    if($func =~ /^[A-Z]+$/) {
      # Built-in function
      print "$func\n";
    } else {
      # custom function
      print "LDF $func\n";
      print "AP " . scalar keys %{$functions->{$func}} . "\n";
    }
  } else {
    if($body =~ /^\d+$/) {
      print "LDC $body\n";
    } else {
      # OK... parameter I guess
      print "LD 0 " . $functions->{$fname}{$body} . "; $fname/$body\n";
    }
  }
}

sub ifzero {
  my ($fname, $cond, $iftrue, $iffalse) = @_;
  sexp($fname, $cond);
  print "SEL iftrue iffalse\n";
  print "RTN\n";

  print "iftrue:\n";
  sexp($fname, $iftrue);
  print "JOIN\n";

  print "iffalse:\n";
  sexp($fname, $iffalse);
  print "JOIN\n";

  return ();
}

def nth => ['list', 'n'],
  ['ifzero', 'n', 
    ['CAR', 'list'],
    ['nth', ['CDR', 'list'], ['SUB', 'n', 1]]];

def getxy => ['matrix', 'x', 'y'],
  ['nth', ['nth', 'matrix', 'y'], 'x'];



