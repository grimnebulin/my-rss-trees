package OnionAVClub;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.avclub.com/feed/daily',
    NAME  => 'avclub',
    TITLE => 'AV Club',
    ITEM_CACHE_MINUTES => 60 * 24,
};

my @TV_I_WATCH = (
    'American Dad',
    'Archer',
    'South Park',
    'The Big Bang Theory',
    'Dexter',
    'Beavis and Butt-Head',
    'Family Guy',
    'Star Trek: Deep Space Nine',
    'Bob\'s Burgers',
    'Game of Thrones',
    'The Legend of Korra',
    'Community',
    'Adventure Time',
    'Cheers',
);

my @TV_I_IGNORE = (
    'The Amazing Race',
    'X Factor',
    'The Office',
    'Scrubs',
    'Survivor',
    'Survivor (Classic)',
    'Leverage',
    'Hell On Wheels',
    'Saturday Night Live',
    'The League',
    'Burn Notice',
    'Psyche',
    'The X Factor',
    'Glee',
    '2 Broke Girls',
    'Terra Nova',
    'American Idol',
    'Seinfeld',
    'Top Chef',
    'Touch',
    'Alias',
    'Remodeled',
    '30 Rock',
    'Unsupervised',
    'The Vampire Diaries',
    'Revenge',
    'Modern Family',
    'The Middle',
    'Suburgatory',
    'Parenthood',
    'Ringer',
    'New Girl',
    'Switched at Birth',
    'Raising Hope',
    'Cougar Town',
    'Being Human',
    'Smash',
    'How I Met Your Mother',
    'House',
    'Pan Am',
    'Angry Boys',
    'House Of Lies',
    'Supernatural',
    'Fringe',
    'Portlandia',
    'The Adventures of Pete and Pete',
    'Project Runway',
    'Californication',
    'Shameless',
    'Mad Men',
    'The Celebrity Apprentice',
    'The Sopranos',
    'The Voice',
    'Lost Girl',
    'RuPaul\'s Drag Race',
    'America\'s Next Top Model',
);


sub init {
    my $self = shift;

    $self->add(
        OnionAVClub::Node
            ->new('savagelove', 'Savage Love')
            ->match_title('Savage Love:'),

        OnionAVClub::Node
            ->new('greatjob', 'Great Job')
            ->match_title('Great Job'),

        OnionAVClub::Node
            ->new('newswire', 'Newswire')
            ->match_title(': Newswire:'),

        OnionAVClub::Node
            ->new('tv', 'TV')
            ->match_title('^TV:')
            ->add(
                OnionAVClub::Node
                    ->new
                    ->match_titles('TV', @TV_I_IGNORE),

                OnionAVClub::Node
                    ->new('tv_i_watch', 'TV I Watch')
                    ->match_titles('TV', @TV_I_WATCH),
            ),

        OnionAVClub::Node::Games
            ->new('games2', 'Games')
            ->match_title('^Games:'),

        OnionAVClub::Node
            ->new('films', 'Films')
            ->match_title('Movie Review'),

        OnionAVClub::Node
            ->new('film', 'Film')
            ->match_title('^(?:Film|DVD):'),

        OnionAVClub::Node
            ->new('books', 'Books')
            ->match_title('^Books:'),

        OnionAVClub::Node
            ->new('music', 'Music')
            ->match_title('^Music:'),

        OnionAVClub::Node::RedMeat
            ->new('redmeat', 'Red Meat')
            ->match_title('Red Meat'),

        OnionAVClub::Node
            ->new('geekery', 'Geekery')
            ->match_title('Gateways to Geekery'),

        OnionAVClub::Node
            ->new('wondermark', 'Wondermark')
            ->match_title('Wondermark'),

    );

}

sub _render_article {
    my ($self, $item) = @_;

    my ($byline) = $item->page->findnodes('//div[%s]', 'byline');

    my ($image) = $item->page->findnodes('//div[%s or %s]/img', 'image', 'review_image');

    my $grade = $item->page->findvalue(
        '//div[%s]/span[%s]', 'title-holder', 'grade'
    );

    my @content = $item->page->findnodes(
        '//div[%s and %s and %s]/*[self::p or self::ul or self::ol or self::blockquote]',
        'article', 'body', 'article_body'
    );

    return (
        $image  ? $self->new_element('p', $image) : (),
        $byline ? $self->new_element('p', $byline->as_text) : (),
        defined $grade && $grade =~ /[[:alpha:]]/
            ? $self->new_element('p', 'Grade: ', ['b', $grade])
            : (),
        @content ? @content : $self->SUPER::render($item)
    );

}

sub render {
    my ($self, $item) = @_;
    return $self->_render_article($item) if $item->title !~ /: Tolerability Index/;
    return ($item->page->findnodes('//div[%s]/img', 'image'))[0];
}


package OnionAVClub::Renderer;

sub _avc_render {
    my ($self, $item) = @_;
    my $page = $item->page;
    my ($image) = $self->_avc_image($page);
    my ($byline) = $self->_avc_byline($page);
    my $grade = $self->_avc_grade($page);
    my @content = $self->_avc_content($page);

    return (
        $image  ? $self->new_element('p', $image) : (),
        $byline ? $self->new_element('p', $byline->as_text) : (),
        defined $grade && $grade =~ /[[:alpha:]]/
            ? $self->new_element('p', 'Grade: ', ['b', $grade])
            : (),
        @content ? @content : $self->SUPER::render($item)
    );

}

sub _avc_byline {
    my ($self, $page) = @_;
    return ($page->findnodes('//div[%s]', 'byline'))[0];
}

sub _avc_image {
    my ($self, $page) = @_;
    return ($page->findnodes('//div[%s]/img', 'image'))[0];
}

sub _avc_grade {
    my ($self, $page) = @_;
    return $page->findvalue('//div[%s]/span[%s]', 'title-holder', 'grade');
}

sub _avc_content {
    my ($self, $page) = @_;
    return $page->findnodes(
        '//div[%s and %s and %s]/*[self::p or self::ul or self::ol or self::blockquote]',
        'article', 'body', 'article_body'
    );
}


package OnionAVClub::Node;

use base qw(RSS::Tree::Node);

*render = *OnionAVClub::_render_article;

sub match_titles {
    my ($self, $prefix, @titles) = @_;
    my $title_re = join '|', map quotemeta, @titles;
    $self->match_title("^\Q$prefix\E: (?i:$title_re)\\b");
}


package OnionAVClub::Node::RedMeat;

use base qw(RSS::Tree::Node);

sub render {
    my ($self, $item) = @_;
    return ($item->page->findnodes('//div[%s]/img', 'image'))[0];
}


package OnionAVClub::Node::Games;

use base qw(RSS::Tree::Node);

sub render {
    my ($self, $item) = @_;

    my ($image)   = $item->page->findnodes('//div[@id="main-content"]/img');
    my ($byline)  = $item->page->findnodes('//h3[@id="byline"]');
    my ($content) = $item->page->findnodes('//div[%s]', 'entry');

    return (
        $image   ? $self->new_element('p', $image) : (),
        $byline  ? $self->new_element('p', $byline->as_text) : (),
        $content ? $content : $self->SUPER::render($item),
    );

}


1;
