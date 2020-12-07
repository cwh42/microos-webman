#!/bin/bash

mandir=/tmp/usr/share/man
toc_file=toc.yml
checknum='^[0-9]+$'

echo -e "docs:\n" > $toc_file

for man in "$@"; do
	file=$(basename $man .gz).html
	title=$(echo $file | sed -E 's/(.*)\.([^\.]*)\.html/\1(\2)/')
        initial=$(tr '[:lower:]' '[:upper:]' <<<  ${title:0:1})
        if [[ $initial =~ $checknum ]] ; then
            initial="0-9"
        fi

	echo -n "Processing $file …"
	echo -e "- title: $title\n  initial: $initial\n  url: $file\n" >> $toc_file
	echo -e "---\ntitle: $title\ninitial: $initial\n---\n" > $file

        zcat $man | groff -I $mandir -mandoc -Thtml >> $file
	echo " done";
done
