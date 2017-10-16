use v6.c;

unit class App::Git:ver<0.0.2>;

=begin pod

=head1 NAME

App::Git - A minimal git interface

=head1 SYNOPSIS

  use App::Git;

=head1 DESCRIPTION

App::Git is a minimal git interface to the git executable. All calls are made via command line.

=head1 AUTHOR

wbiker <wbiker@gmx.at>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 wbiker

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

method pull(:$remote?, :$branch?) {
    if $remote and $branch {
        return self!get-git-output(['pull', $remote, $branch]);
    }

    self!get-git-output(['pull']);
}

method !get-git-output(@command) {
    say $!repository-path;
    my $proc = run <git -C>, $!repository-path, |@command, :out, :err;
    if $proc.exitcode != 0 {
        die "Command failed: " ~ @command.join(' ') ~ " - " ~ $proc.err.slurp-rest.chomp;
    }

    return $proc.out;
}
