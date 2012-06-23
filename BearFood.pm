package BearFood;

use base qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'bearfood',
    TITLE => 'BearFood',
    FEED  => 'http://feeds.feedburner.com/bearfeed',
};


sub render {
    my ($self, $item) = @_;
    my ($anchor) = $item->page->findnodes('//div[@id="link"]//a[@rel]');
    my @content = $item->description;
    push @content, $self->new_element(
        'p', [ 'a', { href => $anchor->attr('href') }, 'Link' ]
    ) if $anchor;
    return @content;
}


1;
