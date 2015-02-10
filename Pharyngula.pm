package Pharyngula;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'pharyngula',
    TITLE => 'Pharyngula',
    FEED  => 'http://feeds.feedburner.com/freethoughtblogs/pharyngula',
    KEEP_GUID => 1,
};


sub test {
    my ($self, $item) = @_;
    return $item->creator =~ /pz/i
        && $item->title !~ /\A\[/
        && $item->title !~ /\]\z/
}

sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[%s]', 'entry-content') or return;
    $self->truncate($content, 'div[%s]', 'sharedaddy');
    $self->remove(
        $content, './/div[contains(@style,"height") and contains(@id,"-ad-")]'
    );
    return $content;
}


1;
