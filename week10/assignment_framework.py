#!/usr/bin/env python3

import sys

import numpy as np

from fasta import readFASTA


#====================#
# Read in parameters #
#====================#

fasta = sys.argv[1]
input_sequences = readFASTA(open(fasta))

seq1_id, sequence1 = input_sequences[0]
seq2_id, sequence2 = input_sequences[1]

# The scoring matrix is assumed to be named "sigma_file" and the 
# output filename is assumed to be named "out_file" in later code


# Read the scoring matrix into a dictionary
sigma_file = sys.argv[2]
fs = open(sigma_file)
sigma = {}
alphabet = fs.readline().strip().split()
for line in fs:
	line = line.rstrip().split()
	for i in range(1, len(line)):
		sigma[(alphabet[i - 1], line[0])] = float(line[i])
fs.close()


# Read in the actual sequences using readFASTA


#=====================#
# Initialize F matrix #
#=====================#
f_matrix = np.zeros((len(sequence1)+1, len(sequence2)+1), dtype= int)

#=============================#
# Initialize Traceback Matrix #
#=============================#
t_matrix = np.zeros((len(sequence1)+1, len(sequence2)+1), dtype= str)


#===================#
# Populate Matrices #
#===================#
gap_penalty = int(sys.argv[3])
for i in range(1, len(sequence1) + 1):
    f_matrix[i, 0] = f_matrix[i -1,0] + gap_penalty
    t_matrix[i, 0] = 'v'

for j in range(1, len(sequence2) + 1): 
    f_matrix[0, j] = f_matrix[0, j -1] + gap_penalty
    t_matrix[0, j] = 'h'



# filling in matrices
for i in range(1, len(sequence1) + 1):
    for j in range(1, len(sequence2) + 1):
        h_score = f_matrix[i, j - 1] + gap_penalty
        v_score = f_matrix[i - 1, j] + gap_penalty
        d_score = f_matrix[i - 1, j - 1] + sigma[(sequence1[i - 1], sequence2[j - 1])]
        highest = max(h_score, v_score, d_score)
        f_matrix[i, j] = highest

        if highest == d_score:
            t_matrix[i, j] = 'd'
        elif highest == v_score:
            t_matrix[i, j] = 'v'
        else:
            t_matrix[i, j] = 'h'

#========================================#
# Follow traceback to generate alignment #
#========================================#
sequence1_alignment = []
sequence2_alignment = []
i = len(sequence1)
j = len(sequence2)
# The aligned sequences are assumed to be strings named sequence1_aligment
# and sequence2_alignment in later code
while i != 0 or j != 0:

    if t_matrix[i,j] == 'd':
        sequence1_alignment.append(sequence1[i-1])
        sequence2_alignment.append(sequence2[j-1])
        i -= 1
        j -= 1
        continue

    if t_matrix[i,j] == 'v':
        sequence1_alignment.append(sequence1[i-1])
        sequence2_alignment.append('-')
        i -= 1
        continue


    if t_matrix[i,j] == 'h':
        sequence1_alignment.append('-')
        sequence2_alignment.append(sequence2[j-1])
        j -= 1
        continue

# reversing them since alignment is backwards
sequence1_alignment = ''.join(sequence1_alignment[::-1])
sequence2_alignment = ''.join(sequence2_alignment[::-1])


#=================================#
# Generate the identity alignment #
#=================================#

# This is just the bit between the two aligned sequences that
# denotes whether the two sequences have perfect identity
# at each position (a | symbol) or not.

identity_alignment = ''
for i in range(len(sequence1_alignment)):
	if sequence1_alignment[i] == sequence2_alignment[i]:
		identity_alignment += '|'
	else:
		identity_alignment += ' '


#===========================#
# Write alignment to output #
#===========================#

# Certainly not necessary, but this writes 100 positions at
# a time to the output, rather than all of it at once.
out_file= sys.argv[4]
output = open(out_file, 'w')

for i in range(0, len(identity_alignment), 100):
	output.write(sequence1_alignment[i:i+100] + '\n')
	output.write(identity_alignment[i:i+100] + '\n')
	output.write(sequence2_alignment[i:i+100] + '\n\n\n')
output.close()


#=============================#
# Calculate sequence identity #
#=============================#

alignment_1_identity = identity_alignment.count("|")/len(sequence1) *100
alignment_2_identity = identity_alignment.count("|")/len(sequence2) *100


#======================#
# Print alignment info #
#======================#

print(sequence1_alignment.count("-"))
print(sequence2_alignment.count("-"))
print(alignment_1_identity)
print(alignment_2_identity)
print(f_matrix[len(sequence1), len(sequence2)])