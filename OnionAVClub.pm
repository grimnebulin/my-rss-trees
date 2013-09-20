package OnionAVClub;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.theonion.com/avclub/daily',
    NAME  => 'avclub',
    TITLE => 'AV Club',
    KEEP_ENCLOSURE => 0,
};

my @TV_I_WATCH2 = (
    [ 'amdad'  , 'American Dad'                    ],
    [ 'bigbang', 'Big Bang Theory'                 ],
    [ 'ds9'    , 'Deep Space Nine'                 ],
    [ 'bob'    , 'Bob.s Burgers', q(Bob's Burgers) ],
    # [ 'got'    , 'Game of Thrones'                 ],
    [ 'korra'  , 'Legend of Korra'                 ],
    [ 'at'     , 'Adventure Time'                  ],
    [ 'sixfeet', 'Six Feet Under'                  ],
    [ 'walking', 'Walking Dead'                    ],
    [ 'sunny'  , 'Always Sunny'                    ],
);

my @TV_I_WATCHED = (
    'Batman: The Animated Series',
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
        RSS::Tree::Node->new('savagelove', 'Savage Love')->match_title('Savage Love:'),
        RSS::Tree::Node->new('greatjob', 'Great Job')->match_title('Great Job'),
        RSS::Tree::Node->new('newswire', 'Newswire')->match_title(': Newswire:'),
        RSS::Tree::Node->new->match_title(_all_titles(@TV_I_IGNORE)),
        RSS::Tree::Node->new('tv_i_watch', 'TV I Watch')
            ->match_title(_all_titles(@TV_I_WATCHED)),
        (map RSS::Tree::Node->new($$_[0], $$_[2] || $$_[1])
                 ->match_title($$_[1]), @TV_I_WATCH2),
        RSS::Tree::Node->new('tv', 'TV')->match_title('^TV:'),
        RSS::Tree::Node->new('films', 'Films')->match_title('Movie Review'),
        RSS::Tree::Node->new('film', 'Film')->match_title('^(?:Film|DVD):'),
        RSS::Tree::Node->new('comics', 'Comics Panel')
            ->match_title('Comics Panel|Big Issues'),
        RSS::Tree::Node->new('books', 'Books')->match_title('^Books:'),
        RSS::Tree::Node->new('music', 'Music')->match_title('^Music:'),
        RSS::Tree::Node->new('geekery', 'Geekery')->match_title('Gateways to Geekery'),
        RSS::Tree::Node->new('comedy', 'Comedy')->match_title('^Comedy:')->add(
            RSS::Tree::Node->new->match_title('Podcast Episode'),
        ),
    );

}

sub render_article {
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

sub render_image {
    my ($self, $item) = @_;
    return ($item->page->find('//div[%s]/img', 'image'))[0];
}

sub render {
    my ($self, $item) = @_;
    return $item->title =~ /: Tolerability Index/
        ? $self->render_image($item)
        : $self->render_article($item);
}

sub _all_titles {
    return '(?:' . join('|', @_) . ')\b';
}

{

package OnionAVClub::RedMeat;

use parent -norequire, qw(OnionAVClub::Node);

sub new {
    return shift->SUPER::new('redmeat', 'Red Meat')->match_title('Red Meat');
}

sub render {
    return shift->root->render_image(@_);
}

}

1;
