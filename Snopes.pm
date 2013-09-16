package Snopes;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.snopes.com/info/whatsnew.rss',
    NAME  => 'snopes',
    TITLE => 'Snopes',
};


sub render {
    my ($self, $item) = @_;
    my @verdict;

    if (my ($divider) = $item->page->find('//img[contains(@src,"content-divider")]')) {
        my $verdict = $divider->parent->right->as_trimmed_text;
        @verdict = $self->new_element(
            'p', 'Verdict: ', $verdict ? [ 'b', $verdict ] : [ 'i', 'not found' ]
        );
    }

    return (@verdict, $self->SUPER::render($item));

}

1;
