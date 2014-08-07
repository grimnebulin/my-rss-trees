package FalsePositive;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'falsepositive',
    TITLE => 'False Positive',
    FEED  => 'http://falsepositivecomic.com/feed/',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//div[@id="comic"]//img');
}


1;
