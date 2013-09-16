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

    for my $e ($item->content->find('//img[following-sibling::node()]')) {
        $self->wrap($e, 'div');
    }

    return;

}


1;
