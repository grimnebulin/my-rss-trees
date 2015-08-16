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

    if (my ($verdict) = get_verdict($item->page)) {
        @verdict = $self->new_element(
            'p', 'Verdict: ', [ 'b', $verdict->as_trimmed_text ]
        );
    }

    return (@verdict, $self->SUPER::render($item));

}

sub get_verdict {
    my $page = shift;
    return $page->find(
        '//img[contains(@src,"content-divider")]/../preceding-sibling::noindex|//span[contains(@style,"xx-large")]'
    );
}

1;
