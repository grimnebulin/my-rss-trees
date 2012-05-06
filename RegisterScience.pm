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
    my ($body) = $item->page->findnodes('//div[@id="article"]');
    $_->detach for $item->findnodes($body, 'descendant::div[%s or %s]', 'ad-now', 'article-nav');
    my ($tags) = $item->findnodes($body, 'child::div[@id="tags"]');
    $_->detach for $tags ? ($tags->right, $tags) : ();
    return $body;
}


1;
