package FailBlog;

use RSS::Tree;
use strict;

our @ISA = qw(RSS::Tree);


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://feeds.feedburner.com/failblog',
        'http://seanmcafee.name/rss/',
        'failblog', 'Fail Blog'
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 5,
        items => 60 * 60 * 24 * 30,
    );

    FailBlogNode
        ->new('failblogvideo', 'Fail Blog Video')
        ->add_to($self);

    return $self;

}

{

package FailBlogNode;

use RSS::Tree::Node;

our @ISA = qw(RSS::Tree::Node);

sub test {
    my ($self, $item) = @_;
    return $item->content->findnodes('//param|//iframe')->size > 0;
}

}

1;
