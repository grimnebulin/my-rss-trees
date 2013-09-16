package OnionAVClub;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.theonion.com/avclub/daily',
    NAME  => 'avclub',
    TITLE => 'AV Club',
    KEEP_ENCLOSURE => 0,
};

my @TV_I_WATCH_NOW = (
    'American Dad',
    'Archer',
    'South Park',
    'The Big Bang Theory',
    'Dexter',
    'Beavis and Butt-Head',
    'Deep Space Nine',
    'Bob.s Burgers',
    'Game of Thrones',
    'Legend of Korra',
    'Adventure Time',
    '^Cheers',
    'Metalocalypse',
    'Six Feet Under',
    'Breaking Bad',
    '^Community',
    'Walking Dead',
    'Gravity Falls',
    'Venture Bros',
);

my @TV_I_WATCH = (
    'Batman: The Animated Series',
    'Firefly',
    'Babylon 5',
    'The Simpsons .Classic',
);

my @TV_I_IGNORE = (
    'The Amazing Race',
    'X Factor',
    '^The Office',
    '^Scrubs',
    '^Survivor',
    '^Survivor .Classic',
    '^Leverage',
    '^Hell On Wheels',
    '^Saturday Night Live',
    '^The League',
    '^Burn Notice',
    '^Psyche',
    '^The X Factor',
    '^Glee',
    '^2 Broke Girls',
    '^Terra Nova',
    '^American Idol',
    '^Seinfeld',
    '^Top Chef',
    '^Touch',
    '^Alias',
    '^Remodeled',
    '^30 Rock',
    '^Unsupervised',
    '^The Vampire Diaries',
    '^Revenge',
    '^Modern Family',
    '^The Middle',
    '^Suburgatory',
    '^Parenthood',
    '^Ringer',
    '^New Girl',
    '^Switched at Birth',
    '^Raising Hope',
    '^Cougar Town',
    '^Being Human',
    '^Smash',
    '^How I Met Your Mother',
    '^House',
    '^Pan Am',
    '^Angry Boys',
    '^House Of Lies',
    '^Supernatural',
    '^Fringe',
    '^Portlandia',
    '^The Adventures of Pete and Pete',
    '^Project Runway',
    '^Californication',
    '^Shameless',
    '^Mad Men',
    '^The Celebrity Apprentice',
    '^The Sopranos',
    '^The Voice',
    '^Lost Girl',
    '^RuPaul.s Drag Race',
    '^America.s Next Top Model',
    '^Veep',
    '^Girls',
    '^The Killing',
    '^So You Think You Can Dance',
    '^Don.t Trust The',
    '^The Big C',
    '^Nurse Jackie',
    '^The West Wing',
    '^MasterChef',
);


sub _node {
    my $node = OnionAVClub::Node->new(@_ ? @_[0,1] : ());
    $node->match_title($_[2]) if @_ >= 3;
    return $node;
}

sub init {
    my $self = shift;

    $self->add(
        _node('savagelove', 'Savage Love', 'Savage Love:'),
        _node('greatjob', 'Great Job', 'Great Job'),
        _node('newswire', 'Newswire', ': Newswire:'),
        _node()->match_titles(@TV_I_IGNORE),
        _node('tv_i_watch', 'TV I Watch')->match_titles(@TV_I_WATCH),
        _node('tv_i_watch_now', 'TV I Watch Now')->match_titles(@TV_I_WATCH_NOW),
        _node('tv', 'TV', '^TV:'),
        OnionAVClub::Games->new,
        _node('films', 'Films', 'Movie Review'),
        _node('film', 'Film', '^(?:Film|DVD):'),
        _node('comics', 'Comics Panel', 'Comics Panel|Big Issues'),
        _node('books', 'Books', '^Books:'),
        _node('music', 'Music', '^Music:'),
        OnionAVClub::RedMeat->new,
        _node('geekery', 'Geekery', 'Gateways to Geekery'),
        _node('comedy', 'Comedy', '^Comedy:')->add(
            _node()->match_title('Podcast Episode'),
        ),
        _node('wondermark', 'Wondermark', 'Wondermark'),
    );

}

sub _render_article {
    my ($self, $item) = @_;

    my ($byline) = $item->page->find('//div[%s]', 'byline');

    my ($image) = $item->page->find('//div[%s or %s]/img', 'image', 'review_image');

    my ($grade) = $item->page->find(
        '//div[%s]/span[%s]', 'title-holder', 'grade'
    );

    my @content = $item->page->find(
        '//div[%s]/*[self::p or self::ul or self::ol or self::blockquote or self::hr]',
        'article_body'
    );

    return (
        $image  && $self->new_element('p', $image),
        $byline && $self->new_element('p', $byline->as_text),
        $grade  && $grade->as_text =~ /([[:alpha:]][-+]?)/ &&
            $self->new_element('p', 'Grade: ', [ 'b', $1 ]),
        @content ? @content : $self->SUPER::render($item),
        $item->title =~ /Wondermark/
            ? $self->new_element('p', $item->body . "")
            : (),
    );

}

sub _render_image {
    my ($self, $item) = @_;
    return ('<p>PRE</p>', ($item->page->find('//div[%s]/img', 'image'))[0], '<p>POST</p>');
}

sub render {
    my ($self, $item) = @_;
    return $item->title =~ /: Tolerability Index/
        ? $self->_render_image($item)
        : $self->_render_article($item);
}


{

package OnionAVClub::Node;

use parent qw(RSS::Tree::Node);

*render = *OnionAVClub::_render_article;

sub match_titles {
    my ($self, @titles) = @_;
    my $title_re = join '|', @titles;
    $self->match_title("(?:$title_re)\\b");
}

}

{

package OnionAVClub::RedMeat;

our @ISA = qw(OnionAVClub::Node);

sub new {
    return shift->SUPER::new('redmeat', 'Red Meat')->match_title('Red Meat');
}

*render = *OnionAVClub::_render_image;

}

{

package OnionAVClub::Games;

our @ISA = qw(OnionAVClub::Node);

sub new {
    return shift->SUPER::new('games', 'Games')->match_title('^Games:');
}

sub render {
    my ($self, $item) = @_;

    my ($image)   = $item->page->find('//div[@id="main-content"]/img');
    my ($byline)  = $item->page->find('//h3[@id="byline"]');
    my ($content) = $item->page->find('//div[%s]', 'entry');

    return (
        $image   ? $self->new_element('p', $image) : (),
        $byline  ? $self->new_element('p', $byline->as_text) : (),
        $content ? $content : $self->SUPER::render($item),
    );

}

}


1;
