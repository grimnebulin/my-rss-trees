package EmacsReddit;

use parent qw(Reddit);
use strict;

use constant {
    NAME  => 'emacsreddit',
    TITLE => 'M-x emacs-reddit',
    FEED  => 'http://www.reddit.com/r/emacs/.rss',
};

1;
