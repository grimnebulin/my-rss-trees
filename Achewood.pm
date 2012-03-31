package Achewood;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.achewood.com/rss.php',
    NAME  => 'achewood',
    TITLE => 'Achewood',
};

sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes('//img[%s]', 'comic')->shift;
}

1;
