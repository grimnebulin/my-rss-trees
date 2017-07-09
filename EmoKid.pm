package EmoKid;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.cheerupemokid.com/feed',
    NAME  => 'emokid',
    TITLE => 'Emo Kid',
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//*[@id="comic"]//img')
        or return;
    my $title = $img->attr('alt');
    return ($img, $title && $self->new_element('p', [ 'i', $title ]));
}


1;
