library(tidyverse)
setwd("/Users/cmdb/qb25-answers/week1")
header <- c("chr", "start", "end", "count")
df_kc <-read_tsv("/Users/cmdb/qb25-answers/week1/hg19-kc-count1.bed", col_names = header)

ggplot(data = df_kc, 
       mapping = aes(x = start,
                     y = count)) +
  geom_line() +
  facet_wrap("chr", scales = "free")

ggsave("exercise1.png")
