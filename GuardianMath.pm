package GuardianMath;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'guardianmath',
    TITLE => 'Guardian Math',
    FEED  => 'http://www.guardian.co.uk/science/mathematics/rss',
    LIMIT => 5,
};


sub render {
    my ($self, $item) = @_;

    my ($content) = $item->page->find('//div[@id="content"]') or return;

    $self->remove($content, './/li[%s]', 'comment-count')
         ->remove($content, './/ul[li[%s]]', 'byline')
         ->remove($content, './/*[*[%s]]', 'email-subscription-promo');

    my ($desc) = $item->page->find('//div[%(itemprop)s]', 'description');

    return (
        $desc && $self->new_element('h2', $desc->as_trimmed_text),
        $content,
    );

}


1;
