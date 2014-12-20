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
        '//map|//*[self::p or self::table][.//img[contains(@src,"doubleclick") or contains(@src,"projectwonderful") or contains(@src,"/images/ads/")]]'
    );

    if (my ($p) = $item->content->find('//p[b[.="***"]')) {
        $p->parent->splice_content(0, $p->pindex + 1);
    }

    $item->content->truncate('//div[%s]', 'yarpp-related-rss');

    if ($item->title =~ /Metapost/) {
        for my $p ($item->content->find('//p')) {
            for my $link ($p->findnodes('.//a[contains(@href,"/images/")]')) {
                $p->postinsert(
                    $self->new_element('p', [ 'img', { src => $link->attr('href') } ])
                );
                $link->replace_with($self->new_element('b', $link->content_list));
            }
        }
    }

    return;

}


1;
