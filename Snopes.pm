package Snopes;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.snopes.com/info/whatsnew.rss',
    NAME  => 'snopes',
    TITLE => 'Snopes',
    LIMIT => 10,
};


sub test {
    my ($self, $item) = @_;
    return $item->description !~ /\b(?:fake|hoax|satire)\b/i;
}

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
    my ($rating) = grep {
        $_->attr('style') !~ /display *: *none/
    } $page->find('//span[@itemtype="http://schema.org/Rating"]');
    $rating or ($rating) = $page->find('//div[%s]', 'claim');
    return $rating ? $self->find($rating, './/span') : ();
}


1;
