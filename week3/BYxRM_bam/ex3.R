library(tidyverse)
setwd("/Users/cmdb/qb25-answers/week3/BYxRM_bam")

gt_long <- read_delim("gt_long.txt", col_names = TRUE)

sample_data <- gt_long %>%
  filter(Sample_ID == "A01_62" & chrom == "chrII") %>%
  mutate(genotype = factor(genotype))

ggplot(data = sample_data, aes(
  x = pos,
  y = 0,
  color = genotype
)) +
  geom_point(size = 3) +
  labs(
    x= "Position on ChrII",
    color = "genotype",
    title = "Genotype of Sample A01_62 on ChrII"
  ) 
#-------------------facet---------------------------------
facet_data <- gt_long %>%
  filter(Sample_ID == "A01_62") %>%
  mutate(genotype = factor(genotype))

ggplot(data = facet_data, aes(
  x = pos,
  y = 0,
  color = genotype
)) +
  geom_point(size = 3) +
  facet_grid(.~chrom, scales = "free_x", space = "free_x") +
  labs(
    x= "Position on ChrII",
    y= "Sample ID",
    color = "genotype",
    title = "Genotypes of Sample A01_62"
  ) 
