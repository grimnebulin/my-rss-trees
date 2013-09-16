package DuckAndCover;

use Image::Size ();
use parent qw(RSS::Tree);
use strict;

use constant {
    FEED     => 'http://feeds2.feedburner.com/blogspot/DuckCover',
    NAME     => 'duckandcover',
    TITLE    => 'Duck And Cover',
    # To force Feedburner to return an RSS feed rather than an Atom feed:
    AGENT_ID => 'Friendster',
};

my $PHANTOM_PATH = '/home/lurch/phantomjs-1.7.0-linux-x86_64/bin/phantomjs';

my $STRIP_DIR = '/home/lurch/www/mallard';

my $STRIP_EXT = 'gif';

my $LOCAL_STRIP_URL = 'http://www.seanmcafee.name/mallard/%s.%s';

my $AGENT_ID =
    'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0';

sub render {
    my ($self, $item) = @_;
    my ($anchor) = $item->description->find('//a[contains(@href,"oregonlive")]')
        or return;
    my ($url, $width, $height) = _cached_mallard_image($anchor->attr('href'))
        or return;
    $anchor->postinsert(
        $self->new_element('img', {
            style  => 'display: block; margin-top: 5px',
            src    => $url,
            width  => $width,
            height => $height,
        })
    );
    return $item->description;  # is this necessary? Could we just return nothing?
}

sub _cached_mallard_image {
    my $url = shift;
    my ($date) = $url =~ /date=([-\d]+)/ or return;
    _cached_strip($date) or eval { _fetch_strip($url, $date) } or return;
    my $path = "$STRIP_DIR/$date.$STRIP_EXT";
    my ($width, $height) = Image::Size::imgsize($path);
    return (sprintf($LOCAL_STRIP_URL, $date, $STRIP_EXT), $width, $height);
}

sub _cached_strip {
    my $date = shift;
    opendir my $dh, $STRIP_DIR or return;
    return 0 < grep {
        substr($_, 0, length($date)) eq $date &&
        substr($_, length($date)) =~ /^\.[^.]+\z/
    } readdir $dh;
}

my $PHANTOM_SCRIPT = <<'EOT';
var args = require("system").args;
var page = require("webpage").create();

page.settings.userAgent = args[1];

page.open(args[2], function () {
    var i = 0;
    setInterval(function() {
        if (++i >= 10) phantom.exit();
        var src = page.evaluate(function () {
            var f = document.getElementById("feature");
            return f && f.getAttribute("src");
        });
        if (src) {
            console.log(">>>" + src);
            phantom.exit();
        }
    }, 1000);

});
EOT

sub _fetch_strip {
    my ($url, $name) = @_;
    my $tries = 0;

    require File::Temp;

    my $script = File::Temp->new;
    print $script $PHANTOM_SCRIPT;
    close $script;

    my ($cookies, $image_url);

    while (1) {
        # print STDERR "Trying...\n";
        $cookies = File::Temp->new;

        defined(my $pid = open my $fh, '-|') or die "Can't fork: $!";

        if ($pid == 0) {
            open STDERR, '>/dev/null';
            { exec $PHANTOM_PATH, "--cookies-file=$cookies",
                   $script, $AGENT_ID, $url; }
            print STDERR "Can't exec: $!\n";
            exit 1;
        }

        my $output = do { local $/; <$fh> };
        close $fh;

        $image_url = $1, last if $output =~ /^>>>(.+)/m;

        die "Can't obtain image URL" if ++$tries >= 20;

    }

    require LWP::UserAgent;
    require HTTP::Cookies::Netscape;

    my $ua = LWP::UserAgent->new(
        agent      => $AGENT_ID,
        cookie_jar => HTTP::Cookies::Netscape->new(file => $cookies),
    );

    my $response = $ua->get($image_url);

    $response->is_success or return;

    my $path = "$STRIP_DIR/$name.$STRIP_EXT";
    open my $fh, '>', $path or die "Can't open $path for writing: $!";
    print $fh $response->decoded_content;
    close $fh;

    return 1;

}

1;
