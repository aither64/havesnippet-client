HaveSnippet Client
==================

CLI for [HaveSnippet](https://github.com/aither64/havesnippet), a self-hosted
paste service.

Installation
------------

    $ gem install havesnippet-client


Usage
-----
There are two executables, `havesnippet` and its abbreviation `hs`.

    $ havesnippet --help
    Usage: havesnippet [options] [file]

    Options:
        -s, --server URL                 URL to the HaveSnippet server
        -k, --api-key KEY                API key used to authenticate the user
        -f, --filename NAME              File name, including the extension
        -l, --language LANG              Language used to highlight the syntax
        -L, --list-languages             List available languages
        -t, --title TITLE                Title for the snippet
        -a, --access MODE                Accessibility (public,unlisted,logged,private)
        -e, --expiration DATE            Date of expiration in ISO 8601
            --hour                       Expiration in one hour
            --day                        Expiration in one day
            --week                       Expiration in one week
            --month                      Expiration in one month
            --year                       Expiration in one year
            --clear                      Clear any previously configured options
            --save                       Save settings to config file
        -h, --help                       Show this message and exit

`havesnippet` either reads from stdin or from `file`, if it is provided as an
argument. It then uploads it using HaveSnippet's API and prints the URL of the
created snippet.

Server address must be provided by the `-s` switch every time, unless a config
file is created using the `--save` switch, e.g.:

    $ havesnippet -s https://paste.vpsfree.cz --save
    $ echo yo! | havesnippet
    https://paste.vpsfree.cz/12345678

Switch `--save` saves all command line options to the config file, so you might
set a default language, title, access mode or expiration.
Options loaded from the config file can be overriden by command line options.
