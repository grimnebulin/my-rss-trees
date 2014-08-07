package HappyJar;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.happyjar.com/feed/',
    NAME  => 'happyjar',
    TITLE => 'Happy Jar',
    LIMIT => 1,
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//div[@id="comic"]/img') or return;
    my ($comment) = $item->page->find('//div[@id="center"]//div[%s]', 'con');
    $self->remove($comment, 'div[%s]', 'like') if $comment;
    return ($self->new_element('div', $img), $comment);
}


1;
