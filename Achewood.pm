package Achewood;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED    => 'http://www.achewood.com/rss.php',
    NAME    => 'achewood',
    TITLE   => 'Achewood',
    KEEP_ENCLOSURE => 0,
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//img[%s]', 'comic') or return;
    my ($title) = $img->attr('title', undef);
    $title = $self->new_element('div', [ 'i', $title ]) if $title;
    return ($img, $title);
}


1;
