package Wonkette;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'wonkette',
    TITLE => 'Wonkette',
    FEED  => 'http://wonkette.com/feed/rss',
};


sub render {
    my ($self, $item) = @_;

    my ($content) = $item->page->find('//div[%s]', 'entry-content');
    $self->truncate($content, './/div[@id="post-supplement"]');
    $self->remove($content, './/div[contains(@id,"-ad-")]');

    if (my ($img) = $content->findnodes('.//img')) {
        if (my ($parent) = $img->findnodes('parent::a')) {
            $parent->replace_with($img);
        }
        $img->preinsert($self->new_element('div'))->left->push_content($img);
        if (my $title = $img->attr('title', undef)) {
            $img->postinsert(
                $self->new_element('div', [ 'i', $title ])
            );
        }
    }

    return $content->content_list;

}


1;
