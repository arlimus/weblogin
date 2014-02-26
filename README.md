# weblogin

A tiny helper to quickly log into a web portal.

When you first use it, e.g. for HotSpot:

    $ weblogin start
    using helper: LogInto::HotSpot
    Enter username for Telekom HotSpot: 4915112345678@t-mobile.de
    Enter password for Telekom HotSpot (will not be shown): ***********
    Finished

And login after that will not ask you for your credentials again. They are stored in `~/.weblogin.conf`.

Currently supports:

* Telekom HotSpot (old-style and some custom urls)
* Telekom HotSpot in Deutsche Bahn, ICE trains
* Telekom HotSpot at Airports
