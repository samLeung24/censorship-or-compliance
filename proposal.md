# Censorship or Legal Compliance? A Glance at X Content Restrictions

## 1. Project Title and Team

**Team:** 
Sam Leung (csleung@uchicago.edu), Krys Reyes (kreyes0@uchicago.edu), Andrew Kaboski (akaboski@uchicago.edu), Catarina Lucas Herrera (catarina1@uchicago.edu)

The project divides into four distinct roles, one for each member: data collection, data checking and cleaning, quantitative analysis and visualization, and research and writing. 

## 2. Project Summary

Governments can pressure X (formerly Twitter) by asking it to remove or withhold content and by demanding non-public user information. Removal restricts what people can read, while identity disclosure may identify speakers and chill future expression. Because many factors exist, simply raw totals do not tell whether these tools are being used similarly by across countries/governments. 

We therefore ask: **Across six countries (US, Japan, India, Turkey, Germany, Brazil) in one recent reporting period, how do X's reported compliance differ between requests for content removal and user information?** 

We will use aggregate records from X's Transparency Center. The results could help journalists, civil-society groups, and users identify where government pressure is concentrated and what X's reporting cannot reveal.

## 3. Related Work

Roberts argues that censorship can operate through fear and friction without completely blocking access [1]. Elmas, Overdorf, and Aberer documented hundreds of thousands of tweets withheld in particular jurisdictions [2]. Gillespie shows that platforms also govern public speech [3]. Transparency-data research cautions that company-reported categories can be inconsistent across time [4].

Our project extends this work through a small comparison of two government pressure mechanisms that are often discussed separately: suppressing content and identifying users. It is descriptive, not an attempt to label every request as censorship.

## 4. Project Preparation and Prerequisites

We will record removal requests, information requests, accounts affected, and compliance rates from X's reports for six countries in a single reporting period. Countries will be selected by high request volume, data completeness, aiming to represent a continent or geographical region. Using one period avoids misleading comparisons across changing report formats. We will also source individual cases from Harvard Law School's Lumen Database [6].

The team will create a documented spreadsheet as the base for analysis, and attempt to produce several figures/charts to visualize the data. No X API, scraping, machine learning, or private data is required. Any Python environment will use conda.

## 5. Evaluation

Two team members will independently check the collected data. We will clearly distinguish requests from accounts affected, report missing values, and avoid comparing across different categories. We will test whether the results change when using requests versus affected accounts. Success means producing a reproducible dataset and accurately answering the research question while identifying limits such as unknown request contents, legal bases, and user-notification outcomes.

## 6. Ethics

Our data collection process minimizes privacy risk. However, request counts alone cannot establish that a government is censoring unlawfully: requests may concern crime, harassment, or other legitimate enforcement. Platform popularity and legal systems also differ by country. We will therefore avoid moral rankings under missing context.

## References

1. Margaret E. Roberts. *Censored: Distraction and Diversion Inside China's Great Firewall*. Princeton University Press, 2018.
2. Tugrulcan Elmas, Rebekah Overdorf, and Karl Aberer. “A Dataset of State-Censored Tweets.” *ICWSM*, 2021. https://arxiv.org/abs/2101.05919
3. Tarleton Gillespie. *Custodians of the Internet*. Yale University Press, 2018.
4. Chiara Drolsbach and Nicolas Prollochs. “Content Moderation on Social Media in the EU: Insights From the DSA Transparency Database.” 2023. https://arxiv.org/abs/2312.04431
5. X. “Transparency Center: Removal Requests and Information Requests.” https://transparency.x.com/
6. Lumen Database: Studying takedown notices along with other legal removal requests and demands concerning online content. https://lumendatabase.org/
