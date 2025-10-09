#!/bin/bash

#------------------------for loop to make read_counts.txt---------------------
output_file="read_counts.txt"
output_file2="bamListFile.txt"

for sample in A01_09 A01_11 A01_23 A01_24 A01_27 A01_31 A01_35 A01_39 A01_62 A01_63
do
samtools index "$sample.bam" >> "$output_file"
done

for sample in A01_09 A01_11 A01_23 A01_24 A01_27 A01_31 A01_35 A01_39 A01_62 A01_63
do
samtools view -c "$sample.bam" >> "$output_file2"
done