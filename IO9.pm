package IO9;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'io9',
    TITLE => 'IO9',
    FEED  => 'http://feeds.gawker.com/io9/full',
};


sub init {
    my $self = shift;
    $self->add(RSS::Tree::Node->new('rbio9', 'TRv2')->match_creator('Bricken'));
}

sub render {
    my ($self, $item) = @_;
    my $creator = $self->new_element(
        'div', 'by ', [ 'i', $item->creator || 'Unknown' ]
    );
    my $intro = $self->_intro($item) || $self->new_element(
        'div', { style => 'border: 1px solid black' }, 'intro not available'
    );
    my ($body) = $item->page->find('//div[%s]', 'post-content') or return;
    $self->remove($body, '//div[%s]|//aside', 'content-ad');
    $self->truncate($body, '//div[@id="inset_groups"]');
    return ($creator, $intro, $body);
}

sub _intro {
    my ($self, $item) = @_;

    if (my ($video) = $item->page->find('//article//iframe[contains(@src,"youtube.com") or contains(@src,"vimeo.com")]')) {
        $video->attr('width', '500');
        $video->attr('height', '400');
        return $self->new_element('div', $video);
    }

    if (my ($img) = $item->page->find('//article//img[%s]', 'js_annotatable-image')) {
        $img->attr($_, int($img->attr($_) * .5)) for qw(width height);
        return $img;
    }

    if (my ($img) = $item->description->find('p[img][count(*)=1]')) {
        return $img;
    }

    return;

}


1;
