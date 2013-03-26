#!/usr/bin/perl

# REPL-style skript to match lines entered via a 'read-eval-print-loop'
# against a regular expression (regex) given by command argument.

# For Term::Readline prefer package libterm-readline-gnu-perl
# to libterm-readline-perl-perl

use warnings;
use strict;

use Term::ReadLine;

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  print "usage: perl $0 <regex>\n";
  exit;
}

my $re = $ARGV[0];
print "pattern: '$re'\n";

# test if regex is valid
eval {
  "" =~ /$re/;
};
if ($@) {
  my $err_msg = $@;
  $err_msg =~ s/ at $0 line \d+.//g;
  print "$err_msg";
  exit;
}

my $term = Term::ReadLine->new("$0");
$term->Attribs->ornaments(0);
my $prompt = "\nline: ";

while ( defined ($_ = $term->readline($prompt)) ) {
  chomp;

  if (my @captures = /$re/) {

    # print text before, of, and after match
    print "Matched:  |$`<$&>$'|\n";

    # print captured text ($1, $2, ...)
    # @captures here contains the captures only if there is at least one capture
    if (defined $1) {
      my $i = 1;
      for my $capture (@captures) {
        # avoid error: 'Use of uninitialized value $capture in concatenation (.) or string'
        if (defined $capture) {
          print "\$$i: $capture\n";
          $i++;
        }
      }
    }

  } else {
    print "No match: |$_|\n";
  }
}
