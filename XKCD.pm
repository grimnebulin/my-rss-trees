package XKCD;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://xkcd.com/rss.xml',
    NAME  => 'xkcd',
    TITLE => 'XKCD',
};


sub render {
    my ($self, $item) = @_;
    my ($image) = $item->description->findnodes('//img');
    $image->postinsert(
        $self->new_element('p', [ 'i', $image->attr('title') ])
    ) if $image;
    return $item->description;
}


1;
