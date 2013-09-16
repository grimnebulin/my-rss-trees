package BasicFeed;

use strict;


sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find($self->_xpath) or return;
    return $content;
}

sub _xpath {
    my $self  = shift;
    my @xpath = $self->CONTENT;
    return @xpath == 1 && ref $xpath[0] eq 'ARRAY' ? @{ $xpath[0] } : @xpath;
}


1;
