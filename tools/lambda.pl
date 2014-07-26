#!/usr/bin/env perl

use strict;
use File::Slurp;
use Data::Dumper;

my $functions = {
  step => {}
};
our $f = '';

my $DEBUG = 0;

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
  } elsif(defined $functions->{$f}{$func}) {
    # OK... parameter I guess
    my $arity = 0;
    if($func =~ /(\d+)$/) {
      $arity = $1;
    }
    $result .= "LD 0 " . $functions->{$f}{$func} . "; $f/$func\n";
    $result .= "AP $arity\n";
  } else {
    # custom function
    # print Dumper($functions->{$func}) . "\n";
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

sub includes {
  my $str = shift;
  $str =~ s/^\s*INCLUDE "(.*?)"/read_file($1)/gme;
  return $str;
}

sub predeclare {
  my $str = shift;
  my @matches = ($str =~ /\(def (\S+) \((.*?)\)/gm);
  while(@matches) {
    my $fname = shift @matches;
    my $p = shift @matches;
    my @args = split(/\s+/, $p);
    foreach my $n (0..@args-1) {
      $functions->{$fname}{$args[$n]} = $n;
    }
  }
}

sub resolve_labels {
  my $original = shift;
  my @lines = split(/\n/, $original);

  my @proggie;
  my %label;

  while(my $line = shift @lines) {
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

  return join("\n", @proggie) . "\n";
}

sub parse {
  my $str = shift;
  $str = includes($str);
  predeclare($str);
  $str =~ tr/()/[]/;
  $str =~ s/\b([\w]+)\b/'$1',/gm;
  $str =~ s/]/],/gm;
  $str =~ s/;.*$//gm;
  my $output = eval "sexp($str)";
  # print "EVAL: sexp($str)\n";
  print "ERROR: $@\n" if $@;
  $output .= $appendix;

  # Disable this line to see the version with labels!
  if(!$DEBUG) {
    $output = resolve_labels($output);
  }

  return $output;
}

if($ARGV[0] eq '-d') {
  $DEBUG = 1;
  shift @ARGV;
}

my $proggie = read_file(shift @ARGV);
print parse($proggie);

