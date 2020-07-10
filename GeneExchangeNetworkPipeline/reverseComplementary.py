#! /usr/bin/env python
from Bio.Seq import Seq; import sys;

seqID=sys.argv[1];  sequence=sys.argv[2];
my_seq = Seq(sequence); reverseComplement=my_seq.reverse_complement()
print seqID+"\t"+reverseComplement
