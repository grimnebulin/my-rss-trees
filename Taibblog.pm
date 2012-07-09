package Taibblog;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.rollingstone.com/siteServices/rss/taibbiBlog',
    NAME  => 'taibblog',
    TITLE => 'Taibblog',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//div[%s]/*', 'blog-post-content');
}


1;
