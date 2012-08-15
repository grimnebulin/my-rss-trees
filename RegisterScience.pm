package RegisterScience;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.theregister.co.uk/science/headlines.rss',
    NAME  => 'registersci',
    TITLE => 'Register Science',
};


sub render {
    my ($self, $item) = @_;
    my ($body) = $item->page->find('//div[@id="article"]');
    $_->detach for $self->find(
        $body, 'descendant::div[%s or %s]', 'ad-now', 'article-nav', 'related-keywords'
    );
    my ($tags) = $body->find('child::div[@id="tags"]');
    $tags->parent->splice_content($tags->pindex) if $tags;
    return $body;
}


1;
