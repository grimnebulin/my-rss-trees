package Cracked;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/CrackedRSS',
    NAME  => 'cracked',
    TITLE => 'Cracked',
};

sub init {
    my $self = shift;
    $self->add(Cracked::Photoplasty->new);
}


package Cracked::Photoplasty;

our @ISA = qw(RSS::Tree::Node);


sub new {
    return shift->SUPER::new('crackedpp', 'Cracked Photoplasty');
}

sub test {
    my ($self, $item) = @_;
    return 0 < (() = $item->page->find('//div[@id="photoplastyStartButtonWrapper"]'));
}

1;
