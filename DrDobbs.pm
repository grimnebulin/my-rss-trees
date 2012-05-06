package DrDobbs;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.drdobbs.com/articles/rss',
    NAME  => 'drdobbs',
    TITLE => 'Dr. Dobb\'s',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes(
        '//*[%s or %s or %s]', 'byline', 'story-teaser', 'story'
    );
}


1;
