package Achewood;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.achewood.com/rss.php',
    NAME  => 'achewood',
    TITLE => 'Achewood',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//img[%s]', 'comic')->shift;
}


1;
