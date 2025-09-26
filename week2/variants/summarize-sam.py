#!/usr/bin/env python3

import sys

chrom_counts = {}
mismatch_counts = {}

my_file = open(sys.argv[1])

for line in my_file:
    #skip header lines
    if line.startswith("@"):
        continue
    fields = line.strip().split ("\t")
    rname = fields[2]
    #count chromosome alignments
    if rname == "*":
        chrom_counts["unmapped"] = chrom_counts.get("unmapped", 0) +1
    else:
        chrom_counts[rname] = chrom_counts.get(rname, 0) + 1
    #find mismatched
    for field in fields[11:]:
        if field.startswith("NM:i:"):
            nm_value = int(field [5:])
            mismatch_counts[nm_value] = mismatch_counts.get(nm_value, 0) + 1
            break

print("=== Alignment counts by chromosome ===")
for chrom, count in  chrom_counts.items():
    print (f"{chrom}\t{count}")
print("\n=== Mismatch counts ===")
for nm in sorted(mismatch_counts.keys()):
    print(f"{nm}\t{mismatch_counts[nm]}")
