package TheDissolve;

use parent qw(RSS::Tree);
use utf8;
use strict;

use constant {
    NAME  => 'thedissolve',
    TITLE => 'The Dissolve',
    FEED  => 'http://thedissolve.com/feeds/site/',
};


sub render {
    my ($self, $item) = @_;

    my ($author) = $item->page->find(
        '//*[self::a or self::span][%s and %s]|//h2[%s]', 'author', 'category', 'author'
    );

    $author = $self->new_element('div', [ 'i', $author->as_trimmed_text ])
        if $author;

    my $stars;

    if (my ($stardiv) = $item->page->find('//div[%s]', 'stars')) {
        $stars = '★' x $self->find($stardiv, 'span[%s]', 'active')->size .
                 '½' x $self->find($stardiv, 'span[%s]', 'half')->size;
    }

    $stars = $self->new_element('div', [ 'b', "Rating: $stars" ])
        if $stars;

    my @images = map { $self->new_element('div', $_) }
                 $item->page->find('//div[@id="header-images"]');

    my ($content) = $item->page->find('//div[%s]', 'article-content')
        or return;

    $self->wrap($_, 'div') for $content->findnodes('.//img');

    return ($author, @images, $stars, $content,);

}


1;

