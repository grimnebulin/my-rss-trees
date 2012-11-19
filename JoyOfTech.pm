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
        if 0 == (my ($thumbnail) = $item->description->find('//a/img'));

    my ($image) = $self->fetch($thumbnail->parent->attr('href'))
                       ->find('//img[contains(@src,"joyimages")]');
    if ($image) {
        $item->absolutize($image, 'src');
        $thumbnail->parent->replace_with($image);
    }

    return $item->description;

}


1;
