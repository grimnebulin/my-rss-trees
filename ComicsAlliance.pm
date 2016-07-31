package ComicsAlliance;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'comicsalliance',
    TITLE => 'Comics Alliance',
    FEED  => 'http://comicsalliance.com/feed/',
    LIMIT => 3,
};


sub render {
    my ($self, $item) = @_;
    return $self->_recurse($item->page->find('//div[%s]', 'the_content'));
}

sub _recurse {
    my $self = shift;
    for my $elem (@_) {
        if (ref $elem) {
            if ($elem->tag eq 'img') {
                $elem = $self->new_element('div', $elem);
            } else {
                $self->_recurse($elem->content_list);
            }
        }
    }
    return @_;
}


1;
