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

    if (my ($verdict) = $self->get_verdict($item->page)) {
        @verdict = $self->new_element(
            'p', 'Verdict: ', [ 'b', $verdict ]
        );
    }

    return (@verdict, $self->SUPER::render($item));

}

sub get_verdict {
    my ($self, $page) = @_;
    for my $div ($page->find('//div[%s]/div', 'article-text')) {
        my $ecount = (() = $self->find($div, '*'));
        my $icount = (() = $self->find($div, 'img'));
        my $scount = (my ($span) = $self->find($div, 'span'));
        if ($ecount == 2 && $icount == 1 && $scount == 1) {
            return $span->as_trimmed_text;
        }
    }
    return;
}

1;
