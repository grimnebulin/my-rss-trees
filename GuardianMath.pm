package GuardianMath;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'guardianmath',
    TITLE => 'Guardian Math',
    FEED  => 'http://www.guardian.co.uk/science/mathematics/rss',
    LIMIT => 5,
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//div[%(itemprop)s]', 'articleBody');
}


1;
