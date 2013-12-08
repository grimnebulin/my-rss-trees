package PhdPlusEpsilon;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'phdpe',
    TITLE => 'PhD Plus Epsilon',
    FEED  => 'http://blogs.ams.org/phdplus/feed/',
};


sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[%s]', 'entry-content') or return;
    $self->truncate($content, 'p[span[contains(@class,"facebook")]]');
    return $content;
}


1;
