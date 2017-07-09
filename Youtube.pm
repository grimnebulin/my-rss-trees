package Youtube;

use HTTP::Request::Common;
use LWP::UserAgent;
use URI::Escape ();
use strict;

my $agent = LWP::UserAgent->new;
# $agent->agent('Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0');

use Data::Dumper;
# die Dumper([Youtube->new->info("0E34d7NXqPQ")]);

# sub new {
#     my $class = shift;
#     bless { }, $class;
# }

sub replace_youtube_videos {
    my ($self, $tree) = @_;
    for my $iframe ($tree->findnodes('.//iframe[@src and @width and @height]')) {
        # warn $iframe->as_HTML;
        my ($video_id) = $iframe->attr('src') =~
            m#^https?://www.youtube.com/embed/([[:alnum:]]+)(?=\?|\z)#
        or next;
        my $width  = $iframe->attr('width');
        my $height = $iframe->attr('height');
        my $area   = $width * $height;
        my @vids = map {
            $_->[0]
        } sort {
            $a->[1] <=> $b->[1]
        } map {
            my $fac = $_->area / $area;
            [ $_, $fac >= 1 ? $fac : 1 / $fac ];
        } grep {
            $_->type =~ m#^video/mp4\b#
        } $self->info($video_id) or next;
        warn Dumper([$video_id, \@vids]);
        $iframe->replace_with(
            $self->new_element(
                'video',
                {
                    controls => 'controls',
                    width    => $width,
                    height   => $height,
                    src      => $vids[0]->url,
                    'data-quality' => $vids[0]->quality,
                    'data-type' => $vids[0]->type,
                }
            )
        );
    }
}


sub info {
    my ($self, $videoid) = @_;
    my $request = GET "https://www.youtube.com/get_video_info?video_id=$videoid";
    warn "https://www.youtube.com/get_video_info?video_id=$videoid";
    my $response = $agent->request($request);
    $response->is_success or die;
    my %hash = vars_of($response->decoded_content);
    my %f = map { (split /\//)[0,1] } split /,/, $hash{fmt_list};
    my @fmt = vars_of($hash{url_encoded_fmt_stream_map});
    my %foo;
    while (my ($key, $value) = splice @fmt, 0, 2) {
        push @{ $foo{$key} }, $value;
    }
    # warn Dumper(\%foo);
    return grep $_, map Youtube::Video->new(
        $foo{url}[$_],
        $f{ $foo{itag}[$_] },
        $foo{quality}[$_],
        $foo{type}[$_]
    ), 0 .. -1 + keys %f;
}

sub vars_of {
    my $str = shift;
    return map URI::Escape::uri_unescape($_), map split(/=/), split /[&,]/, $str;
}

{

package Youtube::Video;

sub new {
    my ($class, $url, $size, $quality, $type) = @_;
    my ($width, $height) = $size =~ /^(\d+)x(\d+)\z/
        # or die qq(Invalid dimensions "$size");
        or return;

    bless {
        url     => $url,
        width   => $width,
        height  => $height,
        area    => $width * $height,
        quality => $quality,
        type    => $type
    }, $class;

}

sub url { shift->{url} }

sub width { shift->{width} }

sub height { shift->{height} }

sub area { shift->{area} }

sub quality { shift->{quality} }

sub type { shift->{type} }

}


1;
