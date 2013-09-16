package SomethingAwful;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'sa',
    TITLE => 'Something Awful',
    FEED  => 'http://www.somethingawful.com/rss/frontpage.xml',
};


sub render {
    my ($self, $item) = @_;

    if (my ($category) = $item->page->find('//div[%s and %s]', 'cavity', 'top')) {
        my $prefix = $category->as_trimmed_text =~ />\s*(.+)/s ? $1 : 'XXX';
        $item->set_title("$prefix: " . $item->title);
    }

    return;

}


1;
