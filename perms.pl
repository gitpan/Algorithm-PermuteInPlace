# Prints out all the permutations of the numbers 1..N.
# The number N is passed on the command line
#
# Example:   perl perms.pl 4

use Algorithm::PermuteInPlace;

die "Usage: perl perms.pl <number>\n" unless @ARGV;

my @array = (1..shift());
my $permutor = Algorithm::PermuteInPlace->new(\@array);
print "@array\n";
print "@array\n" while $permutor->next();
