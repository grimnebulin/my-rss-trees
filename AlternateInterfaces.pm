package AlternateInterfaces;

use Errno;
use parent qw(RSS::Tree);
use strict;


sub tweak_agent {
    my ($self, $agent) = @_;
    if (my @interfaces = _get_interfaces()) {
        $agent->local_address($interfaces[ rand @interfaces ]);
    }
}

sub _get_interfaces {
    my $path = "$ENV{HOME}/.rss-tree-alternate-interfaces.txt";
    if (open my $fh, '<', $path) {
        chomp(my @lines = <$fh>);
        close $fh;
        return @lines;
    } elsif ($!{ENOENT}) {
        return;
    } else {
        die "Failed to open $path for reading: $!";
    }
}


1;
