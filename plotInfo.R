library(ggplot2)
library(ggh4x)
library(dplyr)

# Information requests
information_file <- "data/raw/Twitter_Transparency-Information_Requests_Jul-Dec-2020.csv"

government_info <-
  read.csv(
    file = information_file,
    skip = 1,
    nrows = 863,
    na.strings = "NULL"
  )

non_government_info <-
  read.csv(
    file = information_file,
    skip = 868,
    na.strings = "NULL"
  )

countries <- c(
  "Japan", "Brazil", "United States",
  "Turkey", "India", "Germany"
)

requester_types <- c(
  "Governmental",
  "Non-governmental"
)

# Tidying
## Government
government_trends <- government_info %>%
  filter(
    Country %in% countries,
    grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", Time.period.start)
  ) %>%
  transmute(
    date = as.Date(Time.period.start),
    country = factor(Country, levels = countries),
    requester_type = "Governmental",
    requests = as.numeric(Combined.requests),
    compliance_rate = as.numeric(Combined.compliance.rate)
  )

## Non-government
non_government_trends <- non_government_info %>%
  filter(
    Country %in% countries,
    grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", Time.period.start)
  ) %>%
  transmute(
    date = as.Date(Time.period.start),
    country = factor(Country, levels = countries),
    requester_type = "Non-governmental",
    requests = as.numeric(Information.requests),
    compliance_rate = as.numeric(Compliance)
  )

## Merge tables
info_trends <- bind_rows(
  government_trends,
  non_government_trends
) %>%
  mutate(
    country = factor(country, levels = countries),
    requester_type = factor(
      requester_type,
      levels = requester_types
    )
  ) %>%
  distinct() %>%
  arrange(country, requester_type, date)

## Missing-country warning
missing_countries <- setdiff(
  countries,
  unique(as.character(info_trends$country))
)

if (length(missing_countries) > 0) {
  stop(
    "No information-request data found for: ",
    paste(missing_countries, collapse = ", ")
  )
}

## Scale compliance rates within each country
info_trends <- info_trends %>%
  group_by(country) %>%
  mutate(
    country_max_requests = max(requests, na.rm = TRUE),
    compliance_scaled =
      compliance_rate * country_max_requests
  ) %>%
  ungroup()

## Scaling
country_max <- info_trends %>%
  group_by(country) %>%
  summarise(
    max_requests = max(requests, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(country)

# Plot
## Params
requester_colors <- c(
  "Governmental" = "#B82C2C",
  "Non-governmental" = "#2C7FB8"
)

information_plot <-
  ggplot(
    info_trends,
    aes(
      x = date,
      y = requests,
      group = requester_type
    )
  ) +
  geom_col(
    aes(
      y = compliance_scaled,
      fill = requester_type
    ),
    position = position_dodge(width = 150),
    width = 120,
    alpha = 0.35,
    color = NA
  ) +
  geom_line(
    aes(color = requester_type),
    linewidth = 0.8
  ) +
  geom_point(
    aes(color = requester_type),
    size = 1.5
  ) +
  facet_wrap(
    vars(country),
    scales = "free_y",
    ncol = 2
  ) +
  scale_x_date(
    date_breaks = "2 years",
    date_labels = "%Y"
  ) +
  ggh4x::facetted_pos_scales(
    y = Map(
      function(max_value) {
        scale_y_continuous(
          name = "Information requests",
          limits = c(0, max_value),
          expand = expansion(mult = c(0, 0)),
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
  scale_color_manual(values = requester_colors) +
  scale_fill_manual(values = requester_colors) +
  labs(
    title = "Information requests reported to Twitter",
    subtitle = paste(
      "Governmental and non-governmental requests",
      "by reporting period"
    ),
    x = "Reporting period",
    color = "Requester type",
    fill = "Requester type",
    caption = paste(
      "Source: Twitter Transparency Report,",
      "Information Requests 2020 H2"
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
    legend.position = "bottom",
    legend.title = element_text(size = 9),
    legend.text = element_text(size = 8),
    plot.caption.position = "plot",
    plot.caption = element_text(size = 8, hjust = 1)
  )

## Save
dir.create("plots", showWarnings = FALSE)

ggsave(
  "plots/information_requests_trends.png",
  information_plot,
  width = 7,
  height = 6
)
