BEGIN {
    $| = 1;
    print "1..7\n";
}
END {print "not ok 1\n" unless $loaded;}
use Algorithm::PermuteInPlace;
$loaded = 1;
print "ok 1\n";

my @array = (1..4);
my $permutor = Algorithm::PermuteInPlace->new(\@array);
print (defined $permutor ? "ok 2\n" : "not ok 2\n");

$permutor->next();
print (3 == $array[3] ? "ok 3\n" : "not ok 3\n");
print (4 == $array[2] ? "ok 4\n" : "not ok 4\n");

eval {
    my @array = (1);
    my $permutor = Algorithm::PermuteInPlace->new(\@array);
    @array = (1, 2);
    $permutor->next();
};
print ($@ =~ /Length of array has changed/ ? "ok 5\n" : "not ok 5\n");

my $i = 1;
$i++ while $permutor->next();
print ($i == 23 ? "ok 6\n" : "not ok 6\t# $i\n");

print ($array[0] == 1 ? "ok 7\n" : "not ok 7\t# $array[0]\n");
