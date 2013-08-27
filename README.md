# pocket-to-pinboard

Add everything you add to [Pocket](http://getpocket.com) to your [Pinboard](https://pinboard.in) account, too.

(Pinboard already has a setting for this, but it requires that you set your [Pocket RSS feed] to public. This is script is for you if you want to keep your feed password protected.)


## How it works

`pocket-to-pinboard` is a simple [Ruby](http://ruby-lang.org) script. It uses [httparty][] to access the Pocket feed, [RSS][] (from Ruby’s standard library) to parse the feed, and the [Pinboard Gem][] to push add bookmarks to your Pinboard account.
 
[httparty]: http://rdoc.info/github/jnunemaker/httparty
[RSS]: http://www.ruby-doc.org/stdlib-2.0/libdoc/rss/rdoc/RSS.html
[Pocket RSS feed]: http://help.getpocket.com/customer/portal/articles/482632-can-i-subscribe-to-my-list-via-rss-
[Pinboard Gem]: https://github.com/ryw/pinboard

Notes:
 * All bookmarks added to Pinboard will be tagged with `from:pocket`.
 * Items from your Pocket feed that are already present as Pinboard bookmarks will be ignored (to avoid overwriting bookmarks you may already have edited manually).
 * When run for the first time the script processes all items from your Pocket feed (this may take a while). On subsequent runs, it only processes items that were added since the last run.


## Requirements

The script is designed to be deployed on [Heroku](http://heroku.com). It requires the free [Heroku Scheduler][] and [Redis To Go (nano)][] add-ons. It only runs a [one-off dyno][] every ten minutes, so there should be no monthly cost.

[Heroku Scheduler]: https://devcenter.heroku.com/articles/scheduler
[Redis To Go (nano)]: https://devcenter.heroku.com/articles/redistogo
[one-off dyno]: https://devcenter.heroku.com/articles/one-off-dynos


## Installation

Make sure you have the [Heroku Toolbelt][] installed. If you’re not already logged in, login now (`heroku login`).

[Heroku Toolbelt]: https://toolbelt.heroku.com/

Clone this repository and create your Heroku app:
```bash
$ git clone https://github.com/noniq/pocket-to-pinboard.git
$ cd pocket-to-pinboard
$ heroku create
Creating pure-reaches-9236... done, stack is cedar
http://pure-reaches-9236.herokuapp.com/ | git@heroku.com:pure-reaches-9236.git
Git remote heroku added
```

Add the required add-ons:
```bash
$ heroku addons:add redistogo
Adding redistogo on pure-reaches-9236... done, v3 (free)
Use `heroku addons:docs redistogo` to view documentation.

$ heroku addons:add scheduler:standard 
Adding scheduler:standard on pure-reaches-9236... done, v3 (free)
This add-on consumes dyno hours, which could impact your monthly bill. To learn more:
http://devcenter.heroku.com/addons_with_dyno_hour_usage
To manage scheduled jobs run:
heroku addons:open scheduler
Use `heroku addons:docs scheduler:standard` to view documentation.
```

Now push the app to Heroku:
```bash
$ git push heroku master
[… many lines snipped …]
-----> Compiled slug size: 24.7MB
-----> Launching... done, v4
       http://pure-reaches-9236.herokuapp.com deployed to Heroku
```

## Configuration

You need to provide your username and password for both Pocket and Pinboard:
```bash
$ heroku config:add POCKET_USERNAME=your_pocket_username POCKET_PASSWORD=your_pocket_password 
Setting config vars and restarting pure-reaches-9236... done, v5

$ heroku config:add PINBOARD_USERNAME=your_pinboard_username PINBOARD_PASSWORD=your_pinboard_password
Setting config vars and restarting pure-reaches-9236... done, v6
```

Almost done! To see if everything works correctly, start the script manually **Note: This will already transfer the items from your pocket feed to your pinboard account!**
```bash
$ heroku run bin/pocket-to-pinboard
Running `bin/pocket-to-pinboard` attached to terminal... up, run.3717
Fetching items added since (no last run timestamp available).
[…many lines snipped…]
Successfully transferred 30 items from pocket to pinboard.
```

Finally, configure Heroku Scheduler to run the script every 10 minutes:
```bash
$ heroku addons:open scheduler
```
This will open the Scheduler dashboard in your browser. Click on “Add Job…”, enter `bin/pocket-to-pinboard` and select “1x” and “Every 10 minutes”. Click on “Save” and you’re done!

Use `heroku logs` to see if everything works as expected.


## Additional Notes

### Running without Heroku

The script requires Ruby 2.0.0. Run `bundle` from the application’s directory to install the necessary gems. Make sure you have Redis installed and running. Then start the script like so:
```bash
$ POCKET_USERNAME=… POCKET_PASSWORD=… PINBOARD_USERNAME=… PINBOARD_PASSWORD= REDISTOGO_URL=… bin/pocket.rb
```

### How to Contribute

Fork it, fix it, submit a pull request! :smile:

