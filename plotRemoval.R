library(ggplot2)
library(ggh4x)
library(dplyr)

# Removal requests
removal <- 
  read.csv(file = "data/raw/Twitter_Transparency-Removal_Requests_Jul-Dec-2020.csv",
           skip = 1)

countries <- c("Japan", "Brazil", "United States", "Turkey", "India", "Germany")

## Tidying 
removal_trends <- removal %>%
  filter(
    Country %in% countries,
    grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", Time.period.start)
  ) %>%
  transmute(
    date = as.Date(Time.period.start),
    country = factor(Country, levels = countries),
    requests = as.numeric(Combined.requests),
    compliance_rate = as.numeric(Combined.compliance.rate)
  ) %>%
  distinct() %>%
  arrange(country, date)

## missing value warnings
missing_countries <- setdiff(countries, unique(as.character(removal_trends$country)))
if (length(missing_countries) > 0) {
  stop("No removal data found for: ", paste(missing_countries, collapse = ", "))
}

## Scaling approach
### ADDED: scale each country's bars to its own request maximum
removal_trends <- removal_trends %>%
  group_by(country) %>%
  mutate(
    country_max_requests = max(requests, na.rm = TRUE),
    compliance_scaled = compliance_rate * country_max_requests
  ) %>%
  ungroup()

### ADDED: preserve the same order as the six facets
country_max <- removal_trends %>%
  group_by(country) %>%
  summarise(
    max_requests = max(requests, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(country)

## Plot
#removal_plot <- 
  ggplot(removal_trends, aes(x = date, y = requests)) +
  geom_col(
    aes(y = compliance_scaled), # CHANGED to scale axis
    fill = "grey50",
    alpha = 0.6,
    width = 120
  ) +
  geom_line(linewidth = 0.8, color = "#2C7FB8") +
  geom_point(size = 1.5, color = "#2C7FB8") +
  facet_wrap(
    vars(country),
    scales = "free_y",
    ncol = 2
  ) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  ggh4x::facetted_pos_scales( # ADDED hack
    y = Map(
      function(max_value) {
        scale_y_continuous(
          name = "Combined removal requests",
          limits = c(0, max_value),
          labels = scales::label_comma(),
          sec.axis = sec_axis(
            ~ . / max_value,
            name = "Compliance rate",
            labels = scales::label_percent()
          )
        )
      },
      country_max$max_requests
    )
  ) +
  labs(
    title = "Removal requests reported to Twitter",
    subtitle = "Court orders and other legal demands by reporting period",
    x = "Reporting period",
    caption = paste(
      "Source: Twitter Transparency Report,",
      "Removal Requests 2020 H2"
    )
  ) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title.position = "plot",
    plot.title = element_text(size = 12),
    plot.subtitle = element_text(size = 10),
    strip.text = element_text(size = 9, face = "bold"),
    axis.title = element_text(size = 9),
    axis.text = element_text(size = 8),
    plot.caption.position = "plot",
    plot.caption = element_text(size = 8, hjust = 1)
  )

# Saving plots
dir.create("plots", showWarnings = FALSE)

ggsave(
  "plots/removal_requests_trends.png",
  removal_plot,
  width = 7,
  height = 6
)