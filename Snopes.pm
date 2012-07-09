package Snopes;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.snopes.com/info/whatsnew.rss',
    NAME  => 'snopes',
    TITLE => 'Snopes',
};


sub render {
    my ($self, $item) = @_;
    my @rendered = $self->SUPER::render($item);

    my ($divider) = $item->page->find('//img[contains(@src,"content-divider")]');

    if ($divider) {
        my $verdict = $divider->parent->right->as_text;
        unshift @rendered, $self->new_element(
            'p', 'Verdict: ', $verdict ? ['b', $verdict] : ['i', 'not found']
        );
    }

    return @rendered;

}

1;
