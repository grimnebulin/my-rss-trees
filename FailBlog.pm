package FailBlog;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/failblog',
    NAME  => 'failblog',
    TITLE => 'Fail Blog',
};


sub init {
    my $self = shift;
    $self->add(FailBlogVideo->new('failblogvideo', 'Fail Blog Video'));
}

sub test {
    my ($self, $item) = @_;
    return $item->title !~ /Mini Clip Show/
        && 0 == grep { /\bautoco/i } $item->categories;
}

sub render {
    my ($self, $item) = @_;

    $item->content->remove('//script');

    if (my ($bound) = $item->content->find(
        '//div[.//a[contains(@href,"cheezburger.com/tag/")]]'
    )) {
        my ($prev) = $bound->findnodes(
            'preceding-sibling::*[1][contains(normalize-space()," by:")]'
        );
        $bound->parent->splice_content(($prev || $bound)->pindex);
    }

    return;

}


package FailBlogVideo;

use parent qw(RSS::Tree::Node);

sub test {
    my ($self, $item) = @_;
    return $item->content->find('//param|//iframe')->size > 0;
}


1;
