package OnlyLivingBoy;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://the-only-living-boy.com/feed/',
    NAME  => 'onlylivingboy',
    TITLE => 'The Only Living Boy',
};

sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//div[@id="comic"]/img') or return;
    return map $self->new_element('div', $_), $img, $img->attr('title');
}


1;
