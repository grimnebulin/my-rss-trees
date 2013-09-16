package ComicsCurmudgeon;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/joshreads',
    NAME  => 'comicscurmudgeon',
    TITLE => 'The Comics Curmudgeon',
};


sub render {
    my ($self, $item) = @_;

    $item->content->remove(
        '//map|//*[self::p or self::table][descendant::img[contains(@src,"doubleclick") or contains(@src,"projectwonderful")]]'
    );

    if ($item->title =~ /Metapost/) {
        for my $link ($item->content->find('//p/a[contains(@href,"/images/")]')) {
            $link->parent->postinsert(
                $self->new_element('p', [ 'img', { src => $link->attr('href') } ])
            );
            $link->replace_with($self->new_element('b', $link->content_list));
        }
    }

    return;

}


1;
