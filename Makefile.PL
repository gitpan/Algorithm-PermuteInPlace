BEGIN {
    eval {require Inline::MakeMaker} or do {
        print <<END;
You need the Inline module in order to build this module.
Download it from CPAN, or see http://inline.perl.org/
END
        exit 1;
    };
    Inline::MakeMaker->import();
}

WriteInlineMakefile(
    'NAME'		=> 'Algorithm::PermuteInPlace',
    'VERSION_FROM'	=> 'PermuteInPlace.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
);
