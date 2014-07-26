#!/usr/bin/env perl

use strict;
use Data::Dumper;

my $functions = {
  step => {}
};
our $f = '';

sub def {
  my ($fname, $args, @body) = @_;
  local $f = $fname;
  print "$fname: ; args: @$args\n";
  foreach my $n (0..@$args-1) {
    # print "\$functions->{$fname}{$args->[$n]} = $n;\n";
    $functions->{$fname}{$args->[$n]} = $n;
  }
  foreach my $body (@body) {
    sexp($body);
  }
  print "RTN\n";
}

sub sexp_arg {
  my ($v) = @_;
  if(ref $v eq 'ARRAY') {
    return sexp(@$v);
  }
  if($v =~ /^\d+$/) {
    print "LDC $v\n";
  } elsif(grep { $v eq $_ } keys %{$functions}) {
    print "LDF $v\n";
  } elsif(defined $functions->{$f}{$v}) {
    # OK... parameter I guess
    print "LD 0 " . $functions->{$f}{$v} . "; $f/$v\n";
  } else {
    print "; ERROR $f/$v not found!\n";
    print Dumper($functions);
  }
}

sub apply {
  my ($func, @args) = @_;

  if($func eq 'def') {
    return def(@args);
  }

  if($func eq 'ifzero') {
    return ifzero($func, @args);
  }

  # First we evaluate the parameters, they go on the stack
  map { sexp($_) } @args; # evaluate each arg and put them on the stack

  if($func =~ /^[A-Z]+$/) {
    # Built-in function
    print "$func\n";
  } else {
    # custom function
    print "LDF $func\n";
    print "AP " . (scalar keys %{$functions->{$func}}) . "\n";
  }
}

# Translate an sexp to code, result on stack
sub sexp {
  my (@args) = @_;

  foreach my $arg (@args) {
    if(ref $arg eq 'ARRAY') {
      apply(@$arg);
    } else {
      sexp_arg($arg);
    }
  }
}

sub ifzero {
  my ($fname, $cond, $iftrue, $iffalse) = @_;
  sexp($cond);
  print "SEL $fname\_iftrue $fname\_iffalse\n";
  print "RTN\n";

  print "$fname\_iftrue:\n";
  sexp($iftrue);
  print "JOIN\n";

  print "$fname\_iffalse:\n";
  sexp($iffalse);
  print "JOIN\n";

  return ();
}


sub parse {
  my $str = shift;
  $str =~ tr/()/[]/;
  $str =~ s/\b([\w]+)\b/'$1',/gm;
  $str =~ s/]/],/gm;
  $str =~ s/;.*$//gm;
  # print "EVAL: sexp($str)\n";
  eval "sexp($str)";
  # print $@;
}

use File::Slurp;
my $proggie = read_file(shift @ARGV);

my $nth = "

(def id (n)
  n
)

(def nth (list n)
  (ifzero n
    (CAR list)
    (nth (CDR list) (SUB n 1))
  )
)

(def getxy (matrix x y)
  (nth (nth matrix y) x)
)
";

parse($proggie);
