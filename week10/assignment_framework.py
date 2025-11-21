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
gap_penalty = float(sys.argv[3])

#first column and row for f matrix
for i in range(1, len(sequence1) + 1):
    f_matrix[i, 0] = f_matrix[i -1,0] + gap_penalty

for j in range(1, len(sequence2) + 1): 
    f_matrix[0, j] = f_matrix[0, j -1] + gap_penalty


# first column and row for t mattrix
for i in range(1, len(sequence1) + 1):
    t_matrix[i, 0] = 'v'

for j in range(1, len(sequence2) + 1): 
    t_matrix[0, j] = 'h'

# filling in matrices
for i in range(1, len(sequence1) + 1):
	for j in range(1, len(sequence2)+ 1):
		v_score = f_matrix[i - 1, j] + gap_penalty
		h_score = f_matrix[i, j-1] + gap_penalty
		d_score = sigma[(sequence1[i-1], sequence2[j-1])] + f_matrix[i-1, j-1]
		f_matrix[i, j] = max(v_score, h_score, d_score)
	if f_matrix[i, j] == d_score:
		t_matrix[i,j]== 'd'
		#fill in location in matrix with d
	elif f_matrix[i, j] == v_score:
		t_matrix[i,j] == 'v'
		#fill in location in matrix with v
	else:
		t_matrix[i, j] == 'h'
		#fill in location in matrix with h
		

# t matrix and f matrix must be in same block
# just do if statements over and over because you want the t matrix to be filled with d's, v's, and h's

#========================================#
# Follow traceback to generate alignment #
#========================================#
sequence1_alignment = []
sequence2_alignment = []
i = len(sequence1)
j = len(sequence2)
# The aligned sequences are assumed to be strings named sequence1_aligment
# and sequence2_alignment in later code
while i > 0 or j > 0:
    move = t_matrix[i, j]

    if move == 'd':
        sequence1_alignment.append(sequence1[i-1])
        sequence2_alignment.append(sequence2[j-1])
        i -= 1
        j -= 1

    elif move == 'v':
        sequence1_alignment.append(sequence1[i-1])
        sequence2_alignment.append('-')
        i -= 1

    elif move == 'h':
        sequence1_alignment.append('-')
        sequence2_alignment.append(sequence2[j-1])
        j -= 1
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
gaps_sequence1 = 0
for i in range(len(sequence1_alignment)):
	if sequence1_alignment[i] == '-':
		gaps_sequence1 += 1

gaps_sequence2 = 0
for i in range(len(sequence2_alignment)):
	if sequence2_alignment[i] == '-':
		gaps_sequence2 += 1

# matches between the two aligned sequences
matches = 1
for i in range(len(sequence1_alignment)):
	if sequence1_alignment[i] == sequence2_alignment[i]:
		matches += 1

percent_ident = (matches/len(sequence1_alignment)) *100

alignment_score = f_matrix[len(sequence1), len(sequence2)]

#======================#
# Print alignment info #
#======================#

# You need the number of gaps in each sequence, the sequence identity in
# each sequence, and the total alignment score
print("Alignment Score:", alignment_score)
print('Gaps in sequence 1:', gaps_sequence1)
print('Gaps in sequence 2:', gaps_sequence2)
print(f'Percent identity: {percent_ident: .2f}%')