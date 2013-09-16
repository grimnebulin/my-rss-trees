package PhD;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'phd',
    TITLE => 'PhD Comics',
    FEED  => 'http://www.phdcomics.com/gradfeed.php',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//img[@id="comic"]');
}


1;
