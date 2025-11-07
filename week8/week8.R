library(tidyverse)
library(broom)
library(DESeq2)


setwd("/Users/cmdb/qb25-answers/week8/")

## Exercise 1: Data Preprocessing

# Step 1.1
meta_data_e <- read_delim("gtex_metadata_downsample.txt")
        #gene expression data: columns=subjects(individuals)
        # genes = rows
counts_e <- read_delim("gtex_whole_blood_counts_downsample.txt")

locations_df <- read_delim("gene_locations.txt")

counts_e <- column_to_rownames(counts_e, var = "GENE_NAME") 
counts_e[1:5,]

meta_data_e[1:5,]

# Step 1.2
meta_data_e <- column_to_rownames(meta_data_e, var = "SUBJECT_ID")
colnames(counts_e) == rownames(meta_data_e)

dds_e <- DESeqDataSetFromMatrix(countData = counts_e,
                              colData = meta_data_e,
                              design = ~ SEX + AGE + DTHHRDY )

# Step 1.3
vsde <- vst(dds_e)
plotPCA(vsde, intgroup = "SEX")
ggsave("ex.1.3.PCA.SEX.png")

plotPCA(vsde, intgroup = "AGE")
ggsave("ex.1.3.PCA.AGE.png")

plotPCA(vsde, intgroup = "DTHHRDY")
ggsave("ex.1.3.PCA.DTHHRDY.png")

#ANSWER TO QUESTIONS:
# The proportion of variance in the gene expression data explained by the first
# two principle components is 55%. PC1 seems to be associated with fast death of
# natural causes and ventilator cause. PC2 seems to be associate with sex.

## Exercise 2

# Step 2.1
vsde_df <- assay(vsde) %>%
  t() %>%
  as_tibble()

vsde_df <- bind_cols(meta_data_e, vsde_df)

m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsde_df) %>%
  summary() %>%
  tidy()
m1
#ANSWER TO QUESTION:
# WASH7P does not show significant evidence of sex-differential expression.

m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsde_df) %>%
  summary() %>%
  tidy()
m2
#ANSWER TO QUESTION:
# This gene does show evidence of sex-differential expression with it being up 
# regulated in males.

# Step 2.2
dds_e <- DESeq(dds_e)

# Step 2.3
res <- results(dds_e, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")
FDR_10 <- results(dds_e, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")%>%
  filter(padj < 0.1)

#ANSWER TO QUESTION:
# 262 genes exhibit differential expression between males and females at 10 % FDR.

merged_res <- left_join(res, locations_df, by = "GENE_NAME")

merged_res <- merged_res %>%
  arrange(padj)
head(merged_res)
#ANSWER TO QUESTIONS:
#The y chromosome encodes the genes that are most strongly up-regulated in males.
#The x chromosome encodes the genes that are most strongly up-regulated in females.
# The more male up-regulated genes are near the top of the list this may simply 
# be because of biological sex differences.

#The results are not broadly consistent.

# This analysis illustrates the trade off between false positives and false negatives
# A strict FDR reduces false positives but increases false negatives while a lenient
# one does the opposite. Samples size and effect size improves the power to detect
# true differences even with stricter thresholds.

# Step 2.4
res2 <- results(dds_e, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes")  %>%
  as_tibble(rownames = "GENE_NAME")
FDR_10_2 <- results(dds_e, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes")  %>%
  as_tibble(rownames = "GENE_NAME")%>%
  filter(padj < 0.1)

# ANSWER TO QUESTION
# 16,069 genes are differentially expressed according to death classification at a 10% FDR.

# Step 2.5
meta_data_shuffled <- meta_data_e
meta_data_shuffled$SEX <- sample(meta_data_shuffled$SEX, replace = FALSE)

dds_shuffled <- DESeqDataSetFromMatrix(countData = counts_e,
                                     colData = meta_data_shuffled,
                                     design = ~ SEX + AGE + DTHHRDY)
dds_shuffled <- DESeq(dds_shuffled)

res_shuffled <- results(dds_shuffled, name = "SEX_male_vs_female") %>%
  as_tibble(rownames= "GENE_NAME")

FDR_10_shuffled <- res_shuffled %>%
  filter(padj < 0.1)

#ANSWER TO QUESTION:
# 155 genes appear significant in this permuted analysis at 10% FDR. The number 
# of significant genes from my real analysis was 262. This suggests that the FDR
# threshold does not produces a large number of false positives in these large-scale 
# RNA-seq experiments.

# Exercise 3

res <- results(dds_e, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME") %>%
  mutate(
    neg_log1_padj = -log10(padj),
    significant = if_else(padj < 0.1 & abs(log2FoldChange)>1, "significant", "not significant")
  )
# Got help from chatGBT for the significant = __ part of the code above

ggplot(res, aes(x= log2FoldChange, y = neg_log1_padj)) +
  geom_point(aes(color = significant)) +
  scale_color_manual(values = c("significant" = "red", "not significant" = "black"))+
  labs(
    title = "Volcanot Plot of Differential Expression Between Males and Females",
    x = "log2(Fold Change)",
    y = "-log10 (Adjusted p-value)")
ggsave("exercise3.png")











