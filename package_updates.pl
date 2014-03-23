#!/usr/bin/perl
use strict;
use warnings;
my $n = ((`pacman -Qu` =~ m/^[^\s]+\s\((\d+)\):/m) ? $1 : 0);
if ($n == 0)
{
     print "System is up to date"
}
elsif($n == 1)
{
     print "1 new package available"
}
else
{
     print "$n new packages available"
}
