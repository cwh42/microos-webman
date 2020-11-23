#!/bin/bash

iso_root=/tmp/iso/
man_dir=/usr/share/man/man

read_dom () {
    local IFS=/\>
    read -d \< ENTITY CONTENT
    local ret=$?
    TAG_NAME=${ENTITY%% *}
    ATTRIBUTES=${ENTITY#* }
    return $ret
}

parse_dom () {
    if [[ $TAG_NAME = "package" ]] ; then
        eval local $ATTRIBUTES
        if [[ "$has_man" = true ]]; then
            echo "package: $pkg_file"
            ((pkg_count++))
            if ! rpm2cpio "${iso_root}${pkg_file}" | cpio -ivd ".$man_dir*"; then
                echo "Unpacking $pkg_name failed."
                exit 1
            fi
        fi
        pkg_name="$name"
        pkg_arch=$arch
        has_man=0
    elif [[ $TAG_NAME = "version" ]] ; then
        eval local $ATTRIBUTES
        pkg_file="$pkg_arch/$pkg_name-$ver-$rel.$pkg_arch.rpm"
    elif [[ $TAG_NAME = "file" ]] ; then
        eval local $ATTRIBUTES
        if [[ ${CONTENT:0:18} = $man_dir ]] && [[ $type != "dir" ]] ; then
            has_man=true
            ((file_count++))
        fi
    fi
}

while read_dom; do
    parse_dom
done

echo "Found $file_count man pages in $pkg_count packages."
