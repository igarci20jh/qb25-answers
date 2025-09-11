#!/usr/bin/env python3

import sys
import fasta

my_file = open (sys.argv[1])
contigs = fasta.FASTAReader (my_file)

i = 0
length= 0

for ident, sequence in contigs:
    length = int(length +len (sequence))
    i = int(i+1)

average_length = length/i
#print(f"Name:{ident}\tNumber of Contigs:{i}\tTotal length:{length}\tAverage length:{average_length}")
my_file.close()

my_file = open (sys.argv[1])
contigs = fasta.FASTAReader (my_file)
contigs_len= []

for ident, sequence in contigs:
    length_contig = int(len(sequence))
    contigs_len.append(length_contig)
contigs_len.sort(reverse = True)

cum_length = 0
cumulative_length = []
for c_len in contigs_len:
    cumulative_length.append(c_len)
    cum_length = cum_length + c_len
    if cum_length >= (length/2):
        print(f"The sequence length of the shortest contig at 50% of the total assembly length is {c_len}")
        break
my_file.close()