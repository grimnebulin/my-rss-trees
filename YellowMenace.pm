package YellowMenace;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'yellowmenace',
    TITLE => 'Yellow Menace',
    FEED  => 'http://www.geekyandgenki.com/feed/',
};


sub test {
    my ($self, $item) = @_;
    return $item->creator !~ /Figtree/;
}


1;
