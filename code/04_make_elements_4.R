## Midterm Report Element #4 (Tyler)

cleandata <- readRDS(
  file = here::here("data/cleandata.rds")
)
library(tidyverse)


#stage-specific summaries


wt_dat <- cleandata %>%
  select(subjid, arm, weight, weight1, weight2) %>%
  rename(
    baseline = weight,
    stabilization = weight1,
    discharge_death = weight2
  )

wt_long <- wt_dat %>%
  pivot_longer(
    cols = c(baseline, stabilization, discharge_death),
    names_to = "stage",
    values_to = "weight_kg"
  ) %>%
  mutate(
    stage = factor(
      stage,
      levels = c("baseline", "stabilization", "discharge_death"),
      labels = c("Baseline", "Stabilization", "Discharge/Death")
    ),
    arm = as.factor(arm)
  )

#  Summary table: mean weight at each stage overall and by treatment arm
overall_weight <- wt_long %>%
  group_by(stage) %>%
  summarise(
    n = sum(!is.na(weight_kg)),
    mean_weight = mean(weight_kg, na.rm = TRUE),
    sd_weight = sd(weight_kg, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(arm = "Overall") %>%
  select(arm, stage, n, mean_weight, sd_weight)

by_arm_weight <- wt_long %>%
  group_by(arm, stage) %>%
  summarise(
    n = sum(!is.na(weight_kg)),
    mean_weight = mean(weight_kg, na.rm = TRUE),
    sd_weight = sd(weight_kg, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  select(arm, stage, n, mean_weight, sd_weight)

weight_summary_table <- bind_rows(overall_weight, by_arm_weight)


# change in weight between stages


wt_change <- cleandata %>%
  select(subjid, arm, weight, weight1, weight2) %>%
  mutate(
    change_baseline_to_stabilization = weight1 - weight,
    change_stabilization_to_discharge = weight2 - weight1,
    change_baseline_to_discharge = weight2 - weight
  )

overall_change <- wt_change %>%
  summarise(
    n_baseline_to_stabilization = sum(!is.na(change_baseline_to_stabilization)),
    mean_baseline_to_stabilization = mean(change_baseline_to_stabilization, na.rm = TRUE),
    sd_baseline_to_stabilization = sd(change_baseline_to_stabilization, na.rm = TRUE),
    
    n_stabilization_to_discharge = sum(!is.na(change_stabilization_to_discharge)),
    mean_stabilization_to_discharge = mean(change_stabilization_to_discharge, na.rm = TRUE),
    sd_stabilization_to_discharge = sd(change_stabilization_to_discharge, na.rm = TRUE),
    
    n_baseline_to_discharge = sum(!is.na(change_baseline_to_discharge)),
    mean_baseline_to_discharge = mean(change_baseline_to_discharge, na.rm = TRUE),
    sd_baseline_to_discharge = sd(change_baseline_to_discharge, na.rm = TRUE)
  ) %>%
  mutate(arm = "Overall") %>%
  select(
    arm,
    n_baseline_to_stabilization,
    mean_baseline_to_stabilization,
    sd_baseline_to_stabilization,
    n_stabilization_to_discharge,
    mean_stabilization_to_discharge,
    sd_stabilization_to_discharge,
    n_baseline_to_discharge,
    mean_baseline_to_discharge,
    sd_baseline_to_discharge
  )

by_arm_change <- wt_change %>%
  group_by(arm) %>%
  summarise(
    n_baseline_to_stabilization = sum(!is.na(change_baseline_to_stabilization)),
    mean_baseline_to_stabilization = mean(change_baseline_to_stabilization, na.rm = TRUE),
    sd_baseline_to_stabilization = sd(change_baseline_to_stabilization, na.rm = TRUE),
    
    n_stabilization_to_discharge = sum(!is.na(change_stabilization_to_discharge)),
    mean_stabilization_to_discharge = mean(change_stabilization_to_discharge, na.rm = TRUE),
    sd_stabilization_to_discharge = sd(change_stabilization_to_discharge, na.rm = TRUE),
    
    n_baseline_to_discharge = sum(!is.na(change_baseline_to_discharge)),
    mean_baseline_to_discharge = mean(change_baseline_to_discharge, na.rm = TRUE),
    sd_baseline_to_discharge = sd(change_baseline_to_discharge, na.rm = TRUE),
    .groups = "drop"
  )

weight_change_table <- bind_rows(overall_change, by_arm_change)

# -------------------------------------------------
# 4. Line plot of mean weight trajectory by treatment arm
# -------------------------------------------------

plot_dat <- wt_long %>%
  group_by(arm, stage) %>%
  summarise(
    n = sum(!is.na(weight_kg)),
    mean_weight = mean(weight_kg, na.rm = TRUE),
    se_weight = sd(weight_kg, na.rm = TRUE) / sqrt(n),
    .groups = "drop"
  )

weight_trajectory_plot <- ggplot(
  plot_dat,
  aes(x = stage, y = mean_weight, group = arm, color = arm)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  geom_errorbar(
    aes(ymin = mean_weight - se_weight, ymax = mean_weight + se_weight),
    width = 0.1
  ) +
  labs(
    title = "Average Weight Trajectory Across Clinical Stages by Treatment Arm",
    x = "Clinical Stage",
    y = "Mean Weight (kg)",
    color = "Treatment Arm"
  ) +
  theme_minimal()

# -------------------------------------------------
# 5. Save outputs
# -------------------------------------------------

saveRDS(
  weight_summary_table,
  here::here("output", "weight_summary_table.rds")
)

saveRDS(
  weight_change_table,
  here::here("output", "weight_change_table.rds")
)

saveRDS(
  weight_trajectory_plot,
  here::here("output", "weight_trajectory_plot.rds")
)

# -------------------------------------------------
# 6. Print objects to check
# -------------------------------------------------

weight_summary_table
weight_change_table
weight_trajectory_plot

