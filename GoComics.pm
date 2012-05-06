package GoComics;

use base qw(RSS::Tree);
use strict;
use utf8;

sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes('//img[%s and ./@onload]', 'strip');
}

my @child;

sub _comic {
    my ($pkg, $feedid, $name, $title) = @_;
    my $feed = "http://feeds.feedburner.com/uclick/$feedid";
    no strict 'refs';
    @{ "${pkg}::ISA"   } = __PACKAGE__;
    *{ "${pkg}::FEED"  } = sub { $feed };
    *{ "${pkg}::NAME"  } = sub { $name };
    *{ "${pkg}::TITLE" } = sub { $title };
    push @child, $pkg;
}

sub write_programs {
    $_->new->RSS::Tree::write_programs(use => __PACKAGE__) for @child;
}

_comic('Ballard', 'ballardstreet', 'ballard', 'Ballard Street');
_comic('BloomCounty', 'bloomcounty', 'bloomcounty', 'Bloom County');
_comic('CalvinAndHobbes', 'calvinandhobbes', 'calvin', 'Calvin and Hobbes');
_comic('CulDeSac', 'culdesac', 'culdesac', 'Cul de Sac');
_comic('DancingBug', 'tomethedancingbug', 'dancingbug', 'Tom the Dancing Bug');
_comic('Doonesbury', 'doonesbury', 'doonesbury', 'Doonesbury');
_comic('Lio', 'lio', 'lio', 'Liō');
_comic('NonSequitur', 'nonsequitur', 'nonsequitur', 'Non Sequitur');
_comic('Peanuts', 'peanuts', 'peanuts', 'Peanuts');
_comic('Pearls', 'pearlsbeforeswine', 'pearls', 'Pearls Before Swine');


1;
