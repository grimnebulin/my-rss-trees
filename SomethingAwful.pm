package SomethingAwful;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'sa',
    TITLE => 'Something Awful',
    FEED  => 'http://www.somethingawful.com/rss/frontpage.xml',
};


sub test {
    my ($self, $item) = @_;
    my $category = $item->cache->{category} ||= _category($item->page);
    return $category !~ m#^_(?:Front Page News|Features\s*/\s*Articles|Twitter|Reviews|Video Game Article|Current Release)#;
}

sub render {
    my ($self, $item) = @_;
    $item->set_title(substr(_category($item->page), 1) . ': ' . $item->title);
    return;
}

sub _category {
    my $page = shift;
    my ($category) = $page->find('//div[%s and %s]', 'cavity', 'top')
        or return;
    return $category->as_trimmed_text =~ />\s*(.+)/s ? "_$1" : '_Unknown';
}


1;
