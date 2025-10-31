library(tidyverse)
library(tidyr)
library(dplyr)
library(matrixStats)
setwd("/Users/cmdb/qb25-answers/week7")

data <- as.matrix(read.table("read_matrix.tsv"))
# Step 1.1

filter_data <- rowSds(data) %>%
  order(decreasing = TRUE) %>%
  head(n=500)

# Step 1.2
data2 <- data[filter_data, ]
# Transpose data
transposed <-t(data2)
pca_results = prcomp(transposed)

# Step 1.3
pca_tib = tibble(PC1=pca_results$x[,1],
                 PC2=pca_results$x[,2],
                 sample_names= rownames(transposed))
                 
sep_data<- separate(pca_tib,col= sample_names, into= c("tissue", "replicate"), sep = "_")

ggplot(sep_data, aes(PC1, PC2, color=tissue, shape=replicate)) +
  geom_point(size=3)
ggsave("ex1.3.PCA.plot.png")

pca_summary <- tibble(PC=seq(1,nrow(transposed),1),
                     sd=summary(pca_results)$sdev) %>%
  mutate(norm_var=sd^2/sum(sd^2)) %>%
  mutate(cum_var=cumsum(norm_var))

ggplot(data = pca_summary, aes(x=PC, y=norm_var)) +
  geom_col() +
  labs(y = "Percent variance explained")
ggsave("ex.1.3skree.plot.png")

# Fixing problem from PCA plot (switch LFC.Fe replicate 3 with Fe replicate 1)

data[,c(12,13)] <- data[,c(13,12)]


# Corrected pca plot
filter_data <- rowSds(data) %>%
  order(decreasing = TRUE) %>%
  head(n=500)

data2 <- data[filter_data, ]
#transpose data
transposed <-t(data2)
pca_results = prcomp(transposed)

pca_tib = tibble(PC1=pca_results$x[,1],
                 PC2=pca_results$x[,2],
                 sample_names= rownames(transposed))

sep_data<- separate(pca_tib,col= sample_names, into= c("tissue", "replicate"), sep = "_")

ggplot(sep_data, aes(PC1, PC2, color=tissue, shape=replicate)) +
  geom_point(size=3)
ggsave("ex1.3.PCA.plot.corrected.png")

# Step 2.1
combined <- data[,seq(1, 21, 3)]
combined <- combined + data[,seq(2, 21, 3)]
combined <- combined + data[,seq(3, 21, 3)]
combined <- combined / 3

data_stdh <- rowSds(combined)
data_std <- combined[data_stdh>1,]
   
# Step 2.2
set.seed(42)
kmeans_results <- kmeans(data_std, centers=12, nstart=100)
cluster_labels <- kmeans_results$cluster

sorted <- order(cluster_labels)

sorted_data <- data_std[sorted, ]

sorted_clusters <- cluster_labels[sorted]

heatmap(sorted_data, Rowv=NA, Colv=NA, RowSideColors=RColorBrewer::brewer.pal(12,"Paired")[sorted_clusters], ylab="Gene")
ggsave("heatmap.png")

# Exercise 3
rownames(data_std)[cluster_labels == 6]
rownames(data_std)[cluster_labels == 7]



