#!/bin/bash

for man in "$@"; do
	file=$(basename $man .gz).md
	title=$(echo $file | sed -E 's/(.*)\.([^\.]*)\.md/\1 (\2)/')
	echo -n "Processing $file …"
	echo -e "---\ntitle: $title\ndate: $(date --rfc-3339=seconds)\n---\n" > $file
       	cat $man | pandoc -f man -t markdown_strict -s >> $file
	echo " done";
done
