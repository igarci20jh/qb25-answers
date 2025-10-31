library(tidyverse)
library(palmerpenguins)
library(broom)
library(dplyr)
setwd("/Users/cmdb/qb25-answers/week5")

# Step 1.1
probands <- read_csv("aau1043_dnm.csv")

# Step 1.2
per_proband <- probands %>%
  group_by(Proband_id) %>%
  summarise(
    mother_count= sum(Phase_combined == "mother", na.rm = TRUE),
    father_count= sum(Phase_combined == "father", na.rm = TRUE))
print(per_proband) 

# Step 1.3
parental_ages <- read_csv("aau1043_parental_age.csv")

# Step 1.4
joined <- inner_join(per_proband, parental_ages, by = "Proband_id")

# Step 2.1
ggplot(data= joined, 
       aes(x = mother_count, y = Mother_age))+
  geom_point()
ggsave("ex2_a.png")

ggplot(data= joined, 
       aes(x = father_count, y = Father_age))+
  geom_point()
ggsave("ex2_b.png")

# Step 2.2
m1 <- lm(data = joined, formula = mother_count ~ 1 + Mother_age)
summary(m1)

# Step 2.3
m2 <- lm(data = joined, formula = father_count ~ 1 + Father_age)
summary(m2)

# Step 2.4
new_obs <- tibble(Father_age = 50.5)

predict(m2, newdata = new_obs)

# Step 2.5
joined_long <- joined %>% 
  pivot_longer(
  cols = c(mother_count, father_count),
  names_to = "Parent",
  values_to = "DNM_Count"
)

ggplot(data = joined_long,
       aes(x = DNM_Count,
           fill = Parent
           )) +
  geom_histogram(bins = 20, position = 'identity', alpha = 0.5)+
  labs(title = "DNMs Distributions by Parent",
       y = "Frequency",
       x = "DNM Count")
ggsave("ex2_c.png")

# Step 2.6
t.test(joined$mother_count, joined$father_count, paired = TRUE)
lm(data = joined, formula = mother_count - father_count ~ 1)


# Step 3.2

education <- read.csv("english_education.csv")

## Gross for each musical on week one separated by theater
scores <- education %>%
  select(town11nm, education_score, population_2011)

ggplot(data = scores,
       aes(x = population_2011,
           y = education_score,))+
  geom_point() +
  labs(title = "Relationship Between Population and Education Score ",
       x = "Population",
       y = "Education Score")

ggsave("ex3-2.png")

model<- lm(education_score ~ population_2011, data = education)
summary(model)


















