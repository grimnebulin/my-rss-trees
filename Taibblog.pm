package Taibblog;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.rollingstone.com/siteServices/rss/taibbiBlog',
    NAME  => 'taibblog',
    TITLE => 'Taibblog',
    ITEM_CACHE_MINUTES => 60 * 24,
};

sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes('//div[%s]/*', 'blog-post-content');
}

1;
