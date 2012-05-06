package RegisterScience;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.theregister.co.uk/science/headlines.rss',
    NAME  => 'registersci',
    TITLE => 'Register Science',
};


sub render {
    my ($self, $item) = @_;
    my ($body) = $item->page->findnodes('//div[@id="body"]');
    $_->detach for $item->findnodes($body, 'descendant::div[%s]', 'ad-now');
    my ($tags) = $item->findnodes($body, 'child::div[@id="tags"]');
    $_->detach for $tags ? ($tags->right, $tags) : ();
    return $body;
}


1;
