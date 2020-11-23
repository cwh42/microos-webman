# Extract and convert man-pages from openSUSE MicroOS

This project provides tools for an automated way to extract man-pages from
packages available for openSUSE MicroOS and make them available via a web
framework.

Main focus is the integration in https://microos.opensuse.org which is bases
on Jekyll and its [openSUSE Base Template](https://github.com/openSUSE/jekyll-theme)

## Tools

* man-extractor.sh – parses a *-filelist.xml and uses rpm2cpio & cpio to fetch
  the man pages

* man2md.sh – convert a tree of man-pages to Markdown including a [Front
  Matter](https://jekyllrb.com/docs/front-matter/) suitable for Jekyll.

Work in progess …
