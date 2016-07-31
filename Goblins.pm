package Goblins;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'goblins',
    TITLE => 'Goblins',
    FEED  => 'http://www.goblinscomic.com/feed/',
};


sub test {
    my ($self, $item) = @_;
    return $item->title !~ /live boop/i && $item->content !~ /live boop/i;
}


1;
