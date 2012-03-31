package FailBlog;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/failblog',
    NAME  => 'failblog',
    TITLE => 'Fail Blog',
    ITEM_CACHE_MINUTES => 60 * 24 * 30,
};

sub init {
    my $self = shift;
    $self->add(FailBlogNode->new('failblogvideo', 'Fail Blog Video'));
    return $self;
}

sub render {
    return;
}


package FailBlogNode;

use base qw(RSS::Tree::Node);

sub test {
    my ($self, $item) = @_;
    return $item->content->findnodes('//param|//iframe')->size > 0;
}

sub render {
    return;
}


1;
