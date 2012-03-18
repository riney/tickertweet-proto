tickertweet prototype code
==========================
Okay, so this is the code for a small command-line app that monitors Twitter for tweets to a given hashtag,
and prints them to a Dymo LabelWriter 450. It's sort of a Twitter tickertape. Tickertweet. Bam!

Here's my blog post about it:
http://rineysoft.com/blog/2011/09/tickertweet/

It was featured on Hackaday and Lifehacker, too!
http://hackaday.com/2011/10/01/spamming-a-label-printer-with-cookiehammer/
http://lifehacker.com/5845817/hacking-a-label-printer-into-a-twitter-hashtag-ticker

disclaimer
----------
This is serious one-off hack code. It's intended to make maximum use of off-the-shelf bits, and does
some vaguely grody things, like printing one tweet at a time, and making heavy use of the shell to invoke
command-line conversion and printing apps. It's pretty straightforward to follow, though. This isn't off
the shelf. If you can't make it work, I'm glad to try and help you out, but this is a hack, not shrinkwrap
software with a warranty. :)

requirements
------------
To run it, you'll need, at least:

* A UNIX machine
* A Dymo thermal printer (only tested with the LabelWriter 450)
* lp for printing
* netpbm for image twiddling
* pbm2lwxl to drive the Dymo (available at http://web.archive.org/web/20101021114259/http://www.freelabs.com/~whitis/software/pbm2lwxl/)
* The drivers that came with the Dymo
* imagemagick for your system
* Ruby 1.9
* Bundler (and do a 'bundle install' to set up the necessary ruby libraries)
* an adventuresome spirit to try and get my late-night hacky code running

concept of operation
--------------------
In short, the twitter library searches for tweets, tweet_to_image converts them into a PBM file using RMagick, pnmnoraw converts it into
a format that the dymo driver likes, pbm2lwxl converts that raw image into something the dymo itself likes, and the whole sausagey mess
is piped raw to the Dymo via LP.
