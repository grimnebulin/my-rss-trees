package Oglaf;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.reddit.com/domain/oglaf.com/.rss',
    NAME  => 'myoglaf',
    TITLE => 'Oglaf',
};

sub render {
    my ($self, $item) = @_;
    my $page = $item->page;
    my $oglafpage = $item->page->follow('//a[%s][1]/@href', 'title');
    my ($image) = $oglafpage && $oglafpage->findnodes('//img[@id="strip"]');
    return $image ? $image : ();
}

1;
