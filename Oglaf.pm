package Oglaf;

use base qw(RSS::Tree);
use strict;


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.reddit.com/domain/oglaf.com/.rss',
        'http://seanmcafee.name/rss/',
        'myoglaf', 'Oglaf'
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 60,
        items => 60 * 60 * 24 * 30,
    );

    return $self;

}

sub render {
    my ($self, $item) = @_;
    my $page = $item->page;
    my $oglafpage = $item->page->follow('//a[%s][1]/@href', 'title');
    my ($image) = $oglafpage && $oglafpage->findnodes('//img[@id="strip"]');
    return $image ? $oglafpage->absolutize($image, 'src') : $self->SUPER::render($item);
}

1;
