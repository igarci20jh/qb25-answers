#!/usr/bin/env python3

#-------------allele frequency-------------------------------------
# with open("AF.txt", "w") as out:
#     out.write("Allele_Frequency\n")

#     for line in open("given-biallelic.vcf"):
#         if line.startswith("#"):
#             continue
#         fields = line.rstrip("\n").split("\t")
#         info_field = fields[7]

#         af_value = None 
#         for entry in info_field.split(";"):
#             if entry.startswith("AF="):
#                 af_value = entry.split("=")[1]
#                 break
#         if af_value is not None:
#             out.write(f"{af_value}\n")

#--------------------Read Depth-------------------------------------

with open("DP.txt", "w") as out:
    out.write("Read_Depth\n")

    for line in open("given-biallelic.vcf"):
        if line.startswith("#"):
            continue
        fields = line.rstrip("\n").split("\t")
        format_field = fields[8]
        sample_fields = fields[9:]

        format_keys = format_field.split(":")
        if "DP" in format_keys:
            dp_index = format_keys.index("DP")
        else:
            continue
        for sample in sample_fields:
            sample_values = sample.split(":")
            dp_value = sample_values[dp_index]
            out.write(f"{dp_value}\n")