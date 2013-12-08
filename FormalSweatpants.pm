package FormalSweatpants;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://formalsweatpants.com/feed/',
    NAME  => 'formalsweatpants',
    TITLE => 'Formal Sweatpants',
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//div[@id="comic"]//img') or return;
    return (
        $self->new_element('div', $img),
        $item->description->guts->as_trimmed_text,
    );
}


1;
