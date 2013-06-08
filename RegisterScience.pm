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
    my ($body) = $item->page->find('//div[@id="article"]');
    $self->remove(
        $body, 'descendant::div[%s or %s or %s or %s or %s)]|descendant::h2',
        'ad-now', 'article-nav', 'related-keywords', 'dateline', 'top'
    );
    $self->truncate($body, 'div[@id="tags"]');
    return $body;
}


1;
