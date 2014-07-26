#!/usr/bin/env perl

use strict;
use Data::Dumper;

my $functions = {
  step => {}
};
our $f = '';

my $appendix = '';

sub def {
  my ($fname, $args, @body) = @_;
  my $result = "";
  local $f = $fname;
  $result .= "$fname: ; args: @$args\n";
  foreach my $n (0..@$args-1) {
    $functions->{$fname}{$args->[$n]} = $n;
  }
  foreach my $body (@body) {
    $result .= sexp($body);
  }
  $result .= "RTN\n";
  return $result;
}

sub sexp_arg {
  my ($v) = @_;
  my $result = "";
  if(ref $v eq 'ARRAY') {
    return sexp(@$v);
  }
  if($v =~ /^\d+$/) {
    $result .= "LDC $v\n";
  } elsif(grep { $v eq $_ } keys %{$functions}) {
    $result .= "LDF $v\n";
  } elsif(defined $functions->{$f}{$v}) {
    # OK... parameter I guess
    $result .= "LD 0 " . $functions->{$f}{$v} . "; $f/$v\n";
  } else {
    $result .= "; ERROR $f/$v not found!\n";
    $result .= Dumper($functions);
  }
  return $result;
}

sub apply {
  my ($func, @args) = @_;
  my $result = "";

  if($func eq 'def') {
    return def(@args);
  }

  if($func eq 'if') {
    return ifnonzero($func, @args);
  }

  # First we evaluate the parameters, they go on the stack
  map { $result .= sexp($_) } @args; # evaluate each arg and put them on the stack

  if($func =~ /^[A-Z]+$/) {
    # Built-in function
    $result .= "$func\n";
  } else {
    # custom function
    $result .= "LDF $func\n";
    $result .= "AP " . (scalar keys %{$functions->{$func}}) . "\n";
  }
  return $result;
}

# Translate an sexp to code, result on stack
sub sexp {
  my (@args) = @_;
  my $result = "";

  foreach my $arg (@args) {
    if(ref $arg eq 'ARRAY') {
      $result .= apply(@$arg);
    } else {
      $result .= sexp_arg($arg);
    }
  }
  return $result;
}

my $ifnonzero_count = 0;
sub ifnonzero {
  my ($fname, $cond, $iftrue, $iffalse) = @_;
  my $result = "";
  my $count = $ifnonzero_count++;
  $result .= sexp($cond);
  $result .= "SEL iftrue$count iffalse$count\n";

  my $append = "";
  $append .= "iftrue$count:\n";
  $append .= sexp($iftrue);
  $append .= "JOIN\n";

  $append .= "iffalse$count:\n";
  $append .= sexp($iffalse);
  $append .= "JOIN\n";

  $appendix .= $append;
  return $result;
}

sub predeclare {
  my $str = shift;
  my @matches = ($str =~ /\(def (\S+) \((.*)?\)/gm);
  while(@matches) {
    my $fname = shift @matches;
    my $p = shift @matches;
    my @args = split(/\s+/, $p);
    foreach my $n (0..@args-1) {
      $functions->{$fname}{$args[$n]} = $n;
    }
  }
}

sub parse {
  my $str = shift;
  predeclare($str);
  $str =~ tr/()/[]/;
  $str =~ s/\b([\w]+)\b/'$1',/gm;
  $str =~ s/]/],/gm;
  $str =~ s/;.*$//gm;
  my $output = eval "sexp($str)";
  # print "EVAL: sexp($str)\n";
  print "ERROR: $@\n" if $@;
  $output .= $appendix;
  print $output;
  # print $@;
}

use File::Slurp;
my $proggie = read_file(shift @ARGV);

my $nth = "

(def id (n)
  n
)

(def nth (list n)
  (if n
    (CAR list)
    (nth (CDR list) (SUB n 1))
  )
)

(def getxy (matrix x y)
  (nth (nth matrix y) x)
)
";

parse($proggie);
