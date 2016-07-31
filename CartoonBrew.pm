package CartoonBrew;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'cartoonbrew',
    TITLE => 'Cartoon Brew',
    FEED  => 'http://feeds.feedburner.com/CartoonBrew',
};


sub render {
    my ($self, $item) = @_;
    my @content = $item->page->find('//div[%s][not(footer)]', 'post-inner') or return;
    for my $elem (@content) {
        $self->remove($elem, './/aside');
        $self->remove($elem, './/a[%s]', 'category-slug');
        $self->remove($elem, './/p[%s]', 'byline');
    }
    return @content;
}


1;
