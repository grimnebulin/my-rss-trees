package FailBlog;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/failblog',
    NAME  => 'failblog',
    TITLE => 'Fail Blog',
};

sub init {
    my $self = shift;
    $self->add(
        FailBlogNode->new('failblogvideo', 'Fail Blog Video')
    );
}

sub test {
    my ($self, $item) = @_;
    return $item->title !~ /Mini Clip Show/;
}

sub render {
    my ($self, $item) = @_;
    return $item->content;
}


package FailBlogNode;

use base qw(RSS::Tree::Node);

sub test {
    my ($self, $item) = @_;
    return $item->content->findnodes('//param|//iframe')->size > 0;
}

*render = \&FailBlog::render;


1;
