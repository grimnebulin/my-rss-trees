package XKCD;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://xkcd.com/rss.xml',
    NAME  => 'xkcd',
    TITLE => 'XKCD',
};


sub render {
    my ($self, $item) = @_;
    my ($image) = $item->description->find('//img');
    $image->postinsert(
        $self->new_element('p', [ 'i', $image->attr('title', undef) ])
    ) if $image;
    return $item->description;
}


1;
