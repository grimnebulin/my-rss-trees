package JoyOfTech;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.joyoftech.com/joyoftech/jotblog/index.xml',
    NAME  => 'joyoftech',
    TITLE => 'Joy Of Tech',
};


sub render {
    my ($self, $item) = @_;

    return $self->SUPER::render($item)
        if 0 == (my ($thumbnail) = $item->description->findnodes('//a/img'));

    my ($image) = $self->download($thumbnail->parent->attr('href'))
                       ->findnodes('//img[contains(@alt,"Joy of Tech")]');
    if ($image) {
        $item->absolutize($image, 'src');
        $thumbnail->parent->replace_with($image);
    }

    return $item->description;

}


1;
