package FeministTinder;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://instagrss-mgng.rhcloud.com/feminist_tinder',
    NAME  => 'feministtinder',
    TITLe => 'Feminist Tinder',
};


sub render {
    my ($self, $item) = @_;

    my @image = sort { $b->[1] * $b->[2] <=> $a->[1] * $a->[2] }
                 map { my @s = size($_); @s ? [ $_, @s ] : () }
                     $item->description->find('//a')
        or return;

    my $comment = $item->title;
    if (length $comment > 50 and my ($abbrev) = $comment =~ /^(.{1,50})\b./) {
        $item->set_title($abbrev . '[...]');
    }

    my $image = $image[0];

    return (
        $self->new_element('img', {
            src    => $image->[0]->attr('href'),
            width  => $image->[1],
            height => $image->[2],
        }),
        $self->new_element('p', $comment)
    );

}

sub size {
    my $anchor = shift;
    defined(my $href = $anchor->attr('href')) or return;
    my ($width, $height) = $href =~ m|(\d+)x(\d+)/| or return;
    return ($width, $height);
}


1;
