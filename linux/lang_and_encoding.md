## Environment variables for locale settings and formats

`LANG` determines locale category for any category not specified with an `LC_` variable

`LC_ALL` overrides the value of `LANG` and any other `LC_` variable

### Locale categories:

* `LC_ADDRESS` location and geographic items

* `LC_COLLATE` sorting and regular expressions

* `LC_CTYPE` character classes and bytes sequences interpretation

* `LC_IDENTIFICATION` metadata for the locale

* `LC_MESSAGES` messages and yes/no answers

* `LC_MONETARY` monetary-related numeric values

* `LC_MEASUREMENT` measurement system

* `LC_NAME` addressing people

* `LC_NUMERIC` non-monetary numeric values

* `LC_PAPER` paper size

* `LC_TELEPHONE` telephone sevices

* `LC_TIME` date and time

### Categories support:

* POSIX:

  `LC_CTYPE`, `LC_COLLATE`, `LC_MESSAGES`, `LC_MONETARY`, `LC_NUMERIC`, `LC_TIME`

* GNU C Library 2.2+:

  `LC_ADDRESS`, `LC_IDENTIFICATION`, `LC_MEASUREMENT`, `LC_NAME`, `LC_PAPER`, `LC_TELEPHONE`

> Additional info:
> [bash guide](https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_02.html) |
> [man pages - locale definition file](https://man7.org/linux/man-pages/man5/locale.5.html) |
> [man pages - locale.h C header](https://man7.org/linux/man-pages/man7/locale.7.html)

-------
## `locale` command

`locale` all current locale settings for each category based on environment variables

`locale charmap` current encoding

`locale -a` available locales

`locale -m` available encodings

> Additional info:
> [man pages - locale command](https://man7.org/linux/man-pages/man1/locale.1.html)

-------
## Python

Get stdout encoding:

`python -c "import sys; print(sys.stdout.encoding)"`

> Additional info:
> [python docs - locale encoding](https://docs.python.org/3/glossary.html#term-locale-encoding) |
> [python docs - stdout](https://docs.python.org/3/library/sys.html#sys.stdout)
