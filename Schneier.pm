package Schneier;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.schneier.com/blog/index.xml',
    NAME  => 'schneier',
    TITLE => 'Schneier on Security',
};

sub render {
    my ($self, $item) = @_;
    my ($h3) = $item->page->findnodes('//div[%s]/h3', 'indivbody');
    my @content;

    if ($h3) {
        for my $sibling ($h3->findnodes('following-sibling::*')) {
            my $tag = $sibling->tag;
            next if $tag ne 'p' && $tag ne 'blockquote' && $tag ne 'ol' && $tag ne 'ul';
            push @content, $sibling;
        }
    }

    return @content;

}

1;
