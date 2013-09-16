package ThreeWordPhrase;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.threewordphrase.com/rss.xml',
    NAME  => '3word',
    TITLE => 'Three Word Phrase',
    LIMIT => 3,
};


sub render {
    my ($self, $item) = @_;
    my ($img)  = $item->page->find('//center/img') or return;
    my ($text) = $img->findnodes('ancestor::table[1]/following-sibling::center');
    return ($self->new_element('div', $img), $text ? $text->as_trimmed_text : ());
}


1;
