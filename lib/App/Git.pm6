use v6.c;

unit class App::Git:ver<0.0.1>;

=begin pod

=head1 NAME

App::Git - blah blah blah

=head1 SYNOPSIS

  use App::Git;

=head1 DESCRIPTION

App::Git is ...

=head1 AUTHOR

wolfgangbanaston <wolfgangbanaston@sophos.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 wolfgangbanaston

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

has $.repository-path;

method version() {
    my $version = self!get-git-output(["--version"]);
    if $version.slurp-rest ~~ /(\d+ '.' \d+ '.' \d+)/ {
        return ~$0;
    }
}

method checkout($branch-name) {
    self!get-git-output(["checkout", $branch-name]);
}

method get-all-branches() {
    my $output = self!get-git-output(["branch", "-a"]);

    my @branches;
    for $output.lines -> $line {
        if $line ~~ /(\w+)/ {
            @branches.push(~$0);
        }
    }

    return @branches;
}

method branch-name() {
    my $output = self!get-git-output(["rev-parse", "--abbrev-ref", "HEAD"]);
    return $output.slurp-rest.chomp;
}

method !get-git-output(@command) {
    say $!repository-path;
    my $proc = run <git -C>, $!repository-path, |@command, :out, :err;
    if $proc.exitcode != 0 {
        die "Command failed: " ~ @command.join(' ') ~ " - " ~ $proc.err.slurp-rest.chomp;
    }

    return $proc.out;
}
