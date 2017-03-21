package ComicsAlliance;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'comicsalliance',
    TITLE => 'Comics Alliance',
    FEED  => 'http://comicsalliance.com/feed/',
    LIMIT => 20,
};


sub render {
    my ($self, $item) = @_;
    return (
        $self->new_element('div', [ 'i', $item->creator ]),
        $self->_recurse($item->page->find('//div[%s]', 'the_content'))
    );
}

sub _recurse {
    my $self = shift;
    return map {
        if (ref $_) {
            if ($_->tag eq 'img') {
                $self->new_element('div', $_);
            } else {
                $self->_recurse($_->content_list);
            }
        } else {
            $_;
        }
    } @_;
}


1;
