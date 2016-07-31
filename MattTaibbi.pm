package MattTaibbi;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'taibbi',
    TITLE => 'Matt Taibbi',
    FEED  => 'http://www.rollingstone.com/news.rss',
};


sub test {
    my ($self, $item) = @_;
    my $author = $item->cache->{author} ||= do {
        my ($auth) = $item->page->find('//span[%s]', 'author');
        'x' . (defined $auth ? $auth->as_trimmed_text : "");
    };
    return $author =~ /taibbi/i;
}


1;
