package TheDailyWTF;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'thedailywtf',
    TITLE => 'The Daily WTF',
    FEED  => 'http://syndication.thedailywtf.com/TheDailyWtf',
    WRAP_CONTENT => 1,
};

my $COMMENT_STYLE = 'font-weight: bold; font-size: smaller; font-style: italic';

sub render {
    my ($self, $item) = @_;
    for my $comment ($item->content->find('//comment()')) {
        $comment->replace_with(
            $self->new_element(
                'span', { style => $COMMENT_STYLE }, $comment->attr('text')
            )
        );
    }
    return $item->content;
}


1;
