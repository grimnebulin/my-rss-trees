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

    my ($content) = $item->page->find('//div[@id="content"]/article[1]')
        or return;

    $self->remove($content, './/div[%s]', 'entry-meta');
    $self->remove($content, './/*[self::script or self::footer]');

    return $content;

}


1;
