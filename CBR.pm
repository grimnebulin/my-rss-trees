package CBR;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.comicbookresources.com/feed.php?feed=all',
    NAME  => 'cbr',
    TITLE => 'Comic Book Resources',
};


sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[@id="article-content"]') or return;
    $self->remove($content, 'div[a[@href="#storyContinued"]]');
    $self->truncate($content, 'p[%s]', 'forum');
    return $content;
}


1;
