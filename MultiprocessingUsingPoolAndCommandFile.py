

from multiprocessing import Pool
import sys
import os
taskfile=sys.argv[1]
ncpus=int(sys.argv[2])
pl= Pool(ncpus)
with open(taskfile) as infile:
	lines=infile.readlines()
	pl.map(os.system, lines)


