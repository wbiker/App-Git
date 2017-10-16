use v6.c;
use Test;
plan 5;

use App::Git;

# create test repository. At the moment unix only.
my $test-repo = IO::Spec::Unix.catdir($*TMPDIR, 'appgittestrepo');
run <rm -rf>, $test-repo if $test-repo.IO.e;
$test-repo.IO.mkdir;
run 'git', '-C', $test-repo, 'init', :out;
run 'touch', "$test-repo/testfile";
run <git -C>, $test-repo, <add>, "$test-repo/testfile";
run <git -C>, $test-repo, <commit -m>, "test file commit", :out;

my $rep = App::Git.new(repository-path => $test-repo);

is $rep.version, "2.5.5", "method version returned version.";
is $rep.branch-name, "master", "Proper branch name.";

# create second branch
run <git -C>, $test-repo, <checkout -b test>, :out, :err;

my @branches = <master test>;
is-deeply $rep.get-all-branches(), @branches, "Got all branches";

$rep.checkout("test");
is $rep.branch-name, "test", "New test after checkout";

$rep.checkout("master");
is $rep.branch-name, "master", "Back at master again";

run <rm -rf>, $test-repo;
