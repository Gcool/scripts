#!/usr/bin/perl
use strict;
use warnings;
my $n = ((`pacman -Qu | wc -l`));
print $n;
