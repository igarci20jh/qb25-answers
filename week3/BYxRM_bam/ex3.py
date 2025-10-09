#!/usr/bin/env python3

# Question 3.1
# I think the samples that were derived from the lab strain are A01_09,
# A01_11, A01_23, A01_35, and A01_39.
# the samples I think derived from the wine strain are A01_24, A01_27,
# A01_31, A01_61, and A01_63.

#--------------------------Step 3.2------------------------------------

sample_ids = ["A01_62", "A01_39", "A01_63", "A01_35", "A01_31","A01_27", "A01_24", "A01_23", "A01_11", "A01_09"]

with open("given-biallelic.vcf") as file, open("gt_long.txt", "w") as output:
    output.write("Sample_ID\tchrom\tpos\tgenotype\n")
    for line in file:
        if line.startswith("#"):
            continue
        fields = line.rstrip('\n').split('\t')
        chrom = fields[0]
        pos = fields[1]
        format_field = fields[8]
        sample_fields = fields[9:]
        
        format_keys = format_field.split(':')
        if "GT" in format_keys:
            gt_index = format_keys.index('GT')
        else:
            continue
        for i, sample in enumerate(sample_fields):
            genotype_data = sample.split(':')
            gt = genotype_data[gt_index]
            if gt in ['0','1']:
                output.write(f"{sample_ids[i]}\t{chrom}\t{pos}\t{gt}\n")