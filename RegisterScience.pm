package RegisterScience;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.theregister.co.uk/science/headlines.rss',
    NAME  => 'registersci',
    TITLE => 'Register Science',
};


sub render {
    my ($self, $item) = @_;
    my ($body) = $item->page->find('//div[@id="article"]') or return;
    $self->remove(
        $body,
        './/div[@id="body_side" or @id="in_article_forums" or %s or %s or %s ' .
        'or %s or %s]|.//h2|.//div[%s]/iframe|.//a[contains(@href,"doubleclick")]' .
        '|.//script',
        'ad-now', 'article-nav', 'related-keywords', 'dateline', 'top', 'byline'
    );
    $self->truncate($body, 'div[@id="tags"]');
    return $body;
}


1;
