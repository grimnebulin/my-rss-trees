package DieselSweeties;

use Image::Size ();
use LWP::Simple ();
use base qw(MyRssBase);
use strict;

use constant {
    FEED => 'http://www.dieselsweeties.com/ds-unifeed.xml',
    NAME => 'diesel',
    TITLE => 'Diesel Sweeties',
};

sub render {
    my ($self, $item) = @_;
    for my $image ($item->body->findnodes('//img')) {
        my $content = LWP::Simple::get($image->attr('src'));
        my ($width, $height) = Image::Size::imgsize(\$content);
        $image->attr('width', int($width * .67));
        $image->attr('height', int($height * .67));
    }
    return $item->body;
}

1;
