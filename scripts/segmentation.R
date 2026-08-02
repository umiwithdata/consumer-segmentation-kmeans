##################################################
# Consumer Segmentation using K-Means Clustering
# Author: Umi
##################################################

# Load packages
library(tidyverse)

# Import dataset
customer_data <- read_csv("data/customer_data.csv")

# Preview dataset
head(customer_data)

# Structure of data
glimpse(customer_data)

# Summary statistics
summary(customer_data)

# Dataset dimensions
dim(customer_data)

# Variable names
names(customer_data)

# Data types
sapply(customer_data, class)

customer_data %>%
  select(where(is.numeric)) %>%
  summary()

# Check missing values
colSums(is.na(customer_data))

ggplot(customer_data,
       aes(x = Age)) +
  geom_histogram(
    bins = 15,
    fill = "#2E86DE",
    color = "white"
  ) +
  labs(
    title = "Distribution of Respondents' Age",
    x = "Age",
    y = "Count"
  ) +
  theme_minimal()

ggplot(customer_data,
       aes(x = Monthly_Income_USD)) +
  geom_histogram(
    bins = 20,
    fill = "#00B894",
    color = "white"
  ) +
  labs(
    title = "Monthly Income Distribution",
    x = "Income (USD)",
    y = "Count"
  ) +
  theme_minimal()

ggplot(customer_data,
       aes(x = Smartphone_Budget_USD)) +
  geom_histogram(
    bins = 20,
    fill = "#E17055",
    color = "white"
  ) +
  labs(
    title = "Smartphone Budget Distribution",
    x = "Budget (USD)",
    y = "Count"
  ) +
  theme_minimal()


gender_plot <- ggplot(customer_data,
                      aes(x = Gender,
                          fill = Gender)) +
  geom_bar() +
  labs(
    title = "Gender Distribution",
    x = "",
    y = "Number of Respondents"
  ) +
  theme_minimal()

gender_plot

ggsave(
  "output/gender_distribution.png",
  gender_plot,
  width = 8,
  height = 6,
  dpi = 300
)
occupation_plot <- ggplot(customer_data,
                          aes(x = Occupation,
                              fill = Occupation)) +
  geom_bar() +
  labs(
    title = "Occupation Distribution",
    x = "",
    y = "Number of Respondents"
  ) +
  theme_minimal()

occupation_plot

ggsave(
  "output/occupation_distribution.png",
  occupation_plot,
  width = 8,
  height = 6,
  dpi = 300
)

income_boxplot <- ggplot(customer_data,
                         aes(y = Monthly_Income_USD)) +
    geom_boxplot(fill = "#00B894") +
    labs(
        title = "Monthly Income Boxplot",
        y = "Income (USD)"
    ) +
    theme_minimal()

income_boxplot

ggsave(
    "output/income_boxplot.png",
    income_boxplot,
    width = 8,
    height = 6,
    dpi = 300
)

income_boxplot <- ggplot(customer_data,
                         aes(y = Monthly_Income_USD)) +
  geom_boxplot(fill = "#00B894") +
  labs(
    title = "Monthly Income Boxplot",
    y = "Income (USD)"
  ) +
  theme_minimal()

income_boxplot

ggsave(
  "output/income_boxplot.png",
  income_boxplot,
  width = 8,
  height = 6,
  dpi = 300
)

install.packages("corrplot")

numeric_data <- customer_data %>%
  select(where(is.numeric))

cor_matrix <- cor(numeric_data)

corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  order = "hclust",
  tl.col = "black",
  tl.cex = 0.8,
  addCoef.col = "black",
  number.cex = 0.6
)

install.packages("ggcorrplot")

library(tidyverse)
library(ggcorrplot)
search()

numeric_data <- customer_data %>%
  select(where(is.numeric))

cor_matrix <- cor(numeric_data)

correlation_plot <- ggcorrplot(
  cor_matrix,
  type = "upper",
  lab = TRUE,
  lab_size = 3,
  colors = c("#D73027", "white", "#4575B4"),
  outline.color = "white"
) +
  labs(
    title = "Correlation Matrix of Consumer Attributes"
  ) +
  theme_minimal()

correlation_plot

ggsave(
  filename = "output/correlation_heatmap.png",
  plot = correlation_plot,
  width = 10,
  height = 8,
  dpi = 300
)

library(tidyverse)
library(ggcorrplot)

clustering_data <- customer_data %>%
  select(
    Age,
    Monthly_Income_USD,
    Smartphone_Budget_USD,
    Replacement_Cycle_Years,
    Online_Shopping_Frequency,
    Brand_Loyalty,
    Camera_Importance,
    Gaming_Importance,
    Battery_Importance,
    AI_Feature_Interest,
    Design_Importance,
    Price_Sensitivity,
    Social_Media_Usage,
    Mobile_Gaming,
    Mobile_Photography
  )

glimpse(clustering_data)

##################################################
# 7. Feature Scaling
##################################################

scaled_data <- scale(clustering_data)

head(scaled_data)

colMeans(scaled_data)

apply(scaled_data, 2, sd)

install.packages("factoextra")

library(factoextra)

##################################################
# 8. Determine Optimal Number of Clusters
# Elbow Method
##################################################

fviz_nbclust(
  scaled_data,
  kmeans,
  method = "wss"
) +
  labs(
    title = "Elbow Method for Optimal Number of Clusters"
  ) +
  theme_minimal()

elbow_plot <- fviz_nbclust(
  scaled_data,
  kmeans,
  method = "wss"
) +
  labs(
    title = "Elbow Method for Optimal Number of Clusters"
  ) +
  theme_minimal()

elbow_plot

ggsave(
  "output/elbow_method.png",
  elbow_plot,
  width = 8,
  height = 6,
  dpi = 300
)

##################################################
# 9. K-Means Clustering
##################################################

set.seed(123)

kmeans_result <- kmeans(
  scaled_data,
  centers = 4,
  nstart = 25
)

kmeans_result

customer_data$Cluster <- factor(kmeans_result$cluster)

head(customer_data)

table(customer_data$Cluster)

##################################################
# 10. Cluster Visualization using PCA
##################################################
cluster_plot <- fviz_cluster(
  kmeans_result,
  data = scaled_data,
  geom = "point",
  ellipse.type = "convex",
  palette = "jco",
  ggtheme = theme_minimal()
)

cluster_plot

ggsave(
  "output/cluster_visualization.png",
  cluster_plot,
  width = 9,
  height = 7,
  dpi = 300
)

##################################################
# 11. Cluster Profiling
##################################################
cluster_profile <- customer_data %>%
  group_by(Cluster) %>%
  summarise(
    Age = mean(Age),
    Income = mean(Monthly_Income_USD),
    Budget = mean(Smartphone_Budget_USD),
    Replacement_Cycle = mean(Replacement_Cycle_Years),
    Shopping = mean(Online_Shopping_Frequency),
    Loyalty = mean(Brand_Loyalty),
    Camera = mean(Camera_Importance),
    Gaming = mean(Gaming_Importance),
    Battery = mean(Battery_Importance),
    AI = mean(AI_Feature_Interest),
    Design = mean(Design_Importance),
    Price = mean(Price_Sensitivity),
    Social = mean(Social_Media_Usage),
    MobileGaming = mean(Mobile_Gaming),
    Photography = mean(Mobile_Photography)
  )

cluster_profile

write.csv(
  cluster_profile,
  "output/cluster_profile.csv",
  row.names = FALSE
)

##################################################
# Save Cluster Profile
##################################################

write.csv(
  cluster_profile,
  "output/cluster_profile.csv",
  row.names = FALSE
)

install.packages("reshape2")
library(tidyverse)
library(reshape2)
search()

cluster_profile_plot

cluster_profile_long <- melt(
  cluster_profile,
  id.vars = "Cluster"
)

cluster_profile_plot <- ggplot(
  cluster_profile_long,
  aes(
    x = variable,
    y = value,
    fill = Cluster
  )
) +
  geom_col(position = "dodge") +
  theme_minimal() +
  labs(
    title = "Cluster Profile Comparison",
    x = "",
    y = "Average Value"
  ) +
  theme(
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )

cluster_profile_plot