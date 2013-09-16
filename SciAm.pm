package SciAm;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://rss.sciam.com/ScientificAmerican-Global',
    NAME  => 'sciam',
    TITLE => 'Scientific American',
};


sub render {
    my ($self, $item) = @_;
    my @content;

    if (@content = $item->page->find('//div[@id="articleContent" or @id="singleBlogPost"]')) {
        $self->remove($_, 'div[%s]', 'moduleHolder') for @content;
        $self->wrap($_, 'div') for map { $_->findnodes('.//img') } @content;
    } else {
        @content = $item->page->find('//div[@id="vidFrame"]|//div[@id="vidInfo"]/p');
    }

    return @content;

}


1;
