package StraightDope;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME    => 'straightdope',
    TITLE   => 'Straight Dope',
    FEED    => 'http://www.cityweekly.net/utah/rss-8400-2-the-straight-dope.xml',
};


sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[%s]', 'contentText') or return;
    if (my ($img) = $content->findnodes('a[1]/img')) {
        $img->parent->replace_with($img);
    }
    return $content;
}


1;
