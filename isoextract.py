#!/usr/bin/python

import sys
import os
import pycdio
import iso9660

arg = sys.argv[1]

iso = iso9660.ISO9660.IFS(source=arg)
fd = os.open(arg, os.O_RDONLY)

if not iso.is_open() or fd is None:
    raise Exception("Could not open %s as an ISO-9660 image." % arg)

# On Tumbleweed, there is no '/suse' prefix
for path in ['/repodata']:
    file_stats = iso.readdir(path)
    if file_stats is None:
        continue

    for stat in file_stats:
        filename = stat[0]
        LSN = stat[1]
        size = stat[2]
        sec_size = stat[3]
        is_dir = stat[4] == 2
        print("[LSN %6d] %8d %s%s" % (LSN, size, path,
            iso9660.name_translate(filename)))

        if (filename.endswith('-filelists.xml.gz')):
            os.lseek(fd, LSN * pycdio.ISO_BLOCKSIZE, io.SEEK_SET)

        #if (filename.endswith('.rpm')):
        #    os.lseek(fd, LSN * pycdio.ISO_BLOCKSIZE, io.SEEK_SET)
        #    h = self.ts.hdrFromFdno(fd)
        #    _getdata(h)

os.close(fd)
