package YouTubeInfo;

use LWP::Simple ();
use URI;
use XML::Parser;
use parent qw(Exporter);
use strict;

our @EXPORT_OK = qw(duration);

my $INFO_URI = URI->new('http://gdata.youtube.com/feeds/api/videos/?v=2');


sub duration {
    my $vidid = shift;

    my $uri = $INFO_URI->clone;
    $uri->path($uri->path . $vidid);

    defined(my $info = LWP::Simple::get($uri)) or return;

    my $duration;

    my $parser = XML::Parser->new(
        Handlers => {
            Start => sub {
                my (undef, $tag, %attr) = @_;
                $duration = $attr{seconds} if $tag eq 'yt:duration';
            },
        },
    );

    $parser->parse($info);

    return $duration;

}


1;
