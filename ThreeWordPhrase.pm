package ThreeWordPhrase;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.threewordphrase.com/rss.xml',
    NAME  => '3word',
    TITLE => 'Three Word Phrase',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//center/img');
}


1;
