## Midterm Report Element #2 (Emalee)

cleandata <- readRDS(
  file = here::here("data/cleandata.rds")
)

# Box plot 
x_min <- min(cleandata$days_stable, na.rm = TRUE)
x_max <- max(cleandata$days_stable, na.rm = TRUE)
plot <- ggplot(cleandata, aes(x = days_stable, fill = site)) +
  geom_bar(position = "stack") +
  scale_x_continuous(
    breaks = seq(x_min, x_max),
    limits = c(x_min - 1, x_max + 1)
  ) +
  labs(
    title = "Days to Stabilization by Site",
    x     = "Days to stabilization",
    y     = "Number of patients",
    fill  = "Site"
  ) +
  theme_minimal(base_size = 13) +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5), panel.grid = element_blank(),
        plot.title = element_text(hjust = 0.5))

saveRDS(
  plot,
  file = here::here("output/section2_plot.rds"))

#Table
table <- cleandata |>
    mutate(
    stabilized  = factor(days_stable != 999,
                         levels = c(TRUE, FALSE),
                         labels = c("Stabilized", "Not stabilized")),
    days_clean  = if_else(days_stable != 999, days_stable, NA_real_)
  ) |>
  tbl_summary(
    by        = site,
    include   = c(stabilized, days_clean),
    label     = list(stabilized ~ "Stabilization status",
                     days_clean ~ "Days to stabilization"),
    statistic = list(days_clean  ~ "{mean} ({sd})",
                     stabilized  ~ "{n}"),
    missing   = "no"
  ) |>
  modify_header(all_stat_cols() ~ "**{level}**", label ~ "")|>
  bold_labels()|>
  modify_caption("**Stabilization Summary by Site**")|>
  modify_footnote(everything() ~ NA) |>
  modify_table_styling(
    columns     = label,
    rows        = variable == "stabilized"& row_type == "level",
    footnote    = "n = number of patients"
  ) |>
  modify_table_styling(
    columns     = label,
    rows        = variable == "days_clean",
    footnote    = "Mean (SD) calculated among stabilized patients only"
  )

saveRDS(
  table,
  file = here::here("output/section2_table.rds"))



