package IO9;

use parent qw(MaybeLengthy);
use strict;

use constant {
    NAME  => 'io9',
    TITLE => 'IO9',
    FEED  => 'http://feeds.gawker.com/io9/full',
    TEXT_LIMIT => 10000,
    EMBED_LIMIT => 5,
};


sub init {
    my $self = shift;
    $self->add(RSS::Tree::Node->new('rbio9', 'TRv2')->match_creator('Bricken'));
}

sub get_body {
    my ($self, $page) = @_;
    my ($body) = $page->find('//div[%s]', 'post-content') or return;
    $self->remove($body, '//*[%s or %s]|//aside', 'content-ad', 'hide');
    $self->truncate($body, '//div[@id="inset_groups"]');
    return $body;
}

sub abbreviate {
    my ($self, $item) = @_;
    return $item->description->truncate('//img[@width="1" or @height="1"]');
}

sub postrender {
    my ($self, $item, $body) = @_;
    my $creator = $self->new_element(
        'div', 'by ', [ 'i', $item->creator || 'Unknown' ]
    );
    return ($creator, $self->_intro($item), $body);
}

sub _intro {
    my ($self, $item) = @_;

    if (my ($img) = $item->page->find('//article//img[%s]', 'marquee')) {
        $img->attr($_, int($img->attr($_) * .5)) for qw(width height);
        return $img;
    }

    if (my ($video) = $item->page->find('//article//*[self::iframe or self::embed][contains(@src,"youtube.com") or contains(@src,"vimeo.com") or contains(@src,"ytimg.com")]')) {
        if (0 == grep { $_->getValue eq $video->attr('src') } $item->description->find('//*[self::iframe or self::embed]/@src')) {
            $video->attr('width', '500');
            $video->attr('height', '400');
            return $self->new_element('div', $video);
        }
    }

    if (my ($img) = $item->description->find('p[img][count(*)=1]')) {
        return $img;
    }

    return;

}


1;
