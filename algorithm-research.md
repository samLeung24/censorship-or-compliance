# Research Note: X's Open-Source Content Restriction and Classification Systems

*Research current through July 22, 2026*

## Executive Finding

X has **partially**, but not fully, open-sourced relevant algorithms. Its public repositories expose parts of feed recommendation, training code or orchestration for several safety classifiers, and rules that turn an existing safety or legal label into an action such as downranking, adding a warning, or withholding a post. They do **not** expose the full production moderation system, the process that decides whether a government order is legally valid, or the process that decides whether to disclose user information.

For this project, the most relevant release is Twitter's 2023 [`visibilitylib`](https://github.com/twitter/the-algorithm/tree/main/visibilitylib), because it shows how an already-approved country restriction can be applied to a viewer. It cannot explain why X complied with a request or whether the request was justified.

## Keep Four Systems Separate

| System | Question answered | Publicly available from X? |
|---|---|---|
| Recommendation | Which eligible posts receive attention? | Substantial, but incomplete, code |
| Content classification | Does a post appear abusive, sexual, violent, or spam-like? | Selected models and newer classifier orchestration |
| Visibility enforcement | Given a label, should X drop, label, interstitial, or downrank the post? | A partial 2023 rule engine and a thin 2026 filter |
| Legal compliance | Is a government order valid, and should content or user data be produced? | No decision logic found |

This distinction matters because X's legal-request totals measure company responses to external demands. A toxicity classifier may affect ordinary platform moderation, but it does not establish whether a government legal order was accepted.

## What X Released

### 1. The 2023 Twitter repositories

Twitter released [`twitter/the-algorithm`](https://github.com/twitter/the-algorithm) and [`twitter/the-algorithm-ml`](https://github.com/twitter/the-algorithm-ml) on March 31, 2023. Twitter stated at release that it excluded code that could create safety or privacy risks and did not release training data or model weights (Twitter, 2023a).

The [`trust_and_safety_models`](https://github.com/twitter/the-algorithm/tree/main/trust_and_safety_models) directory contains training code for four model families:

- `pNSFWMedia`: adult or pornographic images;
- `pNSFWText`: adult or sexual text;
- `pToxicity`: insults and some harassment that may not violate X's rules; and
- `pAbuse`: hate speech, targeted harassment, and abusive-rule violations.

This is not a reproducible release of the production classifiers. The files depend on internal Twitter libraries and storage systems, contain redacted SQL and paths, and omit the training data and learned weights. The repository also explicitly says that other models and rules were withheld because moderation is adversarial.

The more relevant component is `visibilitylib`, a centralized rule engine that evaluates pre-existing features and labels. Its public code includes viewer/request country codes, post and author takedown reasons, Digital Millennium Copyright Act (DMCA) media flags, and actions such as `Drop`, labels, interstitials, or ranking signals. It also includes reason types such as `LegalDemandsWithheld`, `LocalLawsWithheld`, and `DmcaWithheld`.

The likely workflow represented by the code is:

1. An upstream system assigns a safety label or country-specific takedown reason.
2. `visibilitylib` combines that feature with the viewing surface and request country.
3. A rule returns an action, such as allowing, labeling, downranking, or dropping the post for that viewer.

The first step is the crucial missing part. The repository does not show how staff determine that an order is valid, how they interpret local law, or how a government demand becomes a takedown reason. Twitter also warned that parts of `visibilitylib` had been removed pending review and that comments were sanitized. X's public country-withholding policy separately says that legal requests are reviewed and that a properly scoped request may lead to withholding only within the relevant jurisdiction (X Corp., n.d.-a).

### 2. The 2026 `xai-org/x-algorithm` release

The current [`xai-org/x-algorithm`](https://github.com/xai-org/x-algorithm) repository is more usable for studying the **For You** recommender. Its May 2026 release includes an end-to-end Phoenix retrieval-and-ranking example and a small pretrained model. It also adds a `grox` content-understanding pipeline and post-selection visibility filtering (xAI, 2026).

The moderation-related code is still incomplete:

- [`grox/classifiers/content`](https://github.com/xai-org/x-algorithm/tree/main/grox/classifiers/content) invokes Grok-based text/vision models for spam and categories including adult content, hate or abuse, violence, illegal or regulated behavior, and self-harm.
- The public files reveal category names and orchestration, but key prompts, model services, internal data types, and enforcement services are missing.
- [`VFFilter`](https://github.com/xai-org/x-algorithm/blob/main/home-mixer/filters/vf_filter.rs) only removes a candidate after another service has already supplied a visibility decision. The actual `xai_visibility_filtering` decision logic is not in the repository.
- No government-order, jurisdictional-takedown, or user-information disclosure workflow was found in this release.

Therefore, the 2026 release is evidence about X's current ranking architecture and broad content-understanding categories, not an open implementation of legal compliance.

X's April 2025 Digital Services Act report fills in part of the operational picture, but it is a company description rather than source code. X says machine-learning models and heuristics flag potentially violating content; some outputs are reviewed by humans and others are actioned automatically according to the model's historical accuracy. For reports of illegal content, reviewers first apply the X Rules, then assess local law if no global rule violation is found, with difficult cases escalated to specialists or in-house counsel (X Corp., 2025). This indicates that legal compliance is a human and organizational process as well as a technical one.

### 3. Copyright and Community Notes

X publicly describes automated copyright matching for live video: a matching broadcast may be disabled or have limited visibility, and the uploader may dispute the claim (X Corp., n.d.-b). However, the matcher, reference database, thresholds, and evaluation results are not public. The old `visibilitylib` exposes only downstream DMCA flags and geographic restrictions.

[`twitter/communitynotes`](https://github.com/twitter/communitynotes) is a more reproducible release: it publishes scoring code and downloadable notes, ratings, and contributor data. It is relevant as an alternative form of content governance, but Community Notes adds context to potentially misleading posts; it does not remove content, execute legal orders, or disclose user information.

## What Independent Research Can Establish

Because the production compliance decision is closed, outside research evaluates **observed outputs**, not the hidden decision rule.

- Elmas, Overdorf, and Aberer (2021) compiled 583,437 country-withheld posts and 4,301 withheld accounts. Their dataset shows that jurisdiction-specific restrictions can be studied at scale, but it does not reveal X's internal legal review.
- Çetinkaya and Elmas (2025) found that withholding was associated with a 25% reduction in likes and reposts and a 90% reduction in follower growth in their sample. Their own classifier predicted which accounts would be withheld with an F1 score of 0.73 and an area under the curve of 0.83. This is a third-party predictive model, **not X's classifier**.
- Bouchaud, Chavalarias, and Panahi (2023) audited recommendation outcomes and found uneven political amplification and greater exposure to toxic and emotionally charged posts among their participants. This evaluates attention allocation, not government-request compliance.
- Trujillo, Fagni, and Cresci (2025) found substantial inconsistencies in platforms' self-reported Digital Services Act records, especially X's early submissions. This supports describing the project data as **X-reported compliance**, rather than verified ground truth.

## Short Comparison with Meta and YouTube

| Area | X | Meta | YouTube |
|---|---|---|---|
| Recommendation | Public production-oriented repositories; 2026 includes a small runnable model | Public system cards describe signals and predictions, but no complete production feed repository was found | Research papers describe candidate generation and ranking, but no complete production repository was found |
| Moderation | Selected 2023 model training code and partial visibility rules; 2026 classifier orchestration | Public process descriptions explain proactive detection, automated high-confidence action, prioritization, and human review; production code and weights are not public | Public descriptions say classifiers nominate likely violations and humans review most categories; production code and weights are not public |
| Copyright | Automated live-video matching is described; matching code is closed | Rights Manager uses image/video matching; implementation is closed | Content ID automatically matches uploaded audio/video and can block, monetize, or track by geography; implementation is closed |
| Government orders | Review and disclosure decision logic not public | No complete public legal-demand decision system found | No complete public legal-demand decision system found |

Meta's 22 system cards provide structured, nontechnical explanations of ranking stages and important prediction models (Meta, 2023). Its content-review documentation describes AI detection, automation, and prioritization, while Rights Manager uses matching technology for copyrighted media (Meta, 2020a, 2020b). These are transparency documents and products, not source releases of the production enforcement stack.

YouTube has published a high-level two-stage recommendation architecture consisting of candidate generation and ranking (Covington et al., 2016). It also explains that machine learning identifies potentially violative material for review and that human reviewers remain important for contextual judgments (YouTube, 2022). Content ID is the clearest copyright comparison: every upload is scanned against rightsholder-provided audio and video references, after which a match can produce a geography-specific block, monetization, or tracking action (YouTube, n.d.). The matching algorithm and database are proprietary.

Overall, X exposes more directly relevant enforcement code than Meta or YouTube through the old `visibilitylib`, while Meta and YouTube provide clearer process descriptions and outcome reporting in some areas. None of the three provides enough public code to reproduce the full path from a government demand to removal, withholding, or disclosure of user information.

## Recommended Use in This Report

The algorithm section should be a short mechanism-and-limitations subsection, not a separate quantitative analysis. Its defensible finding is:

> X has open-sourced parts of content recommendation, safety classification, and visibility enforcement, but not the legal-review process that determines compliance with government orders. The 2023 visibility code suggests that approved country restrictions are implemented through takedown-reason and viewer-country features that trigger withholding actions. Consequently, the code helps explain how a restriction can be delivered geographically, but it cannot explain why X accepted an order or whether disclosure of user information was warranted.

Three cautions should accompany this paragraph:

1. Code released in 2023 or 2026 does not prove that the same system operated unchanged during the project's July-December 2021 data period.
2. Platform-rule classification and legal-demand compliance are separate processes, even when both ultimately restrict visibility.
3. The open-source code cannot be used to calculate compliance rates or compare the six countries; those findings must come from the archived transparency CSVs and country context.

## References

Bouchaud, P., Chavalarias, D., & Panahi, M. (2023). Crowdsourced audit of Twitter's recommender systems. *Scientific Reports, 13*, Article 16815. [https://doi.org/10.1038/s41598-023-43980-4](https://doi.org/10.1038/s41598-023-43980-4)

Covington, P., Adams, J., & Sargin, E. (2016). Deep neural networks for YouTube recommendations. In *Proceedings of the 10th ACM Conference on Recommender Systems* (pp. 191-198). Association for Computing Machinery. [https://doi.org/10.1145/2959100.2959190](https://doi.org/10.1145/2959100.2959190)

Çetinkaya, Y. M., & Elmas, T. (2025). State and geopolitical censorship on Twitter (X): Detection and impact analysis of withheld content [Preprint]. *arXiv*. [https://doi.org/10.48550/arXiv.2508.13375](https://doi.org/10.48550/arXiv.2508.13375)

Elmas, T., Overdorf, R., & Aberer, K. (2021). A dataset of state-censored tweets. *Proceedings of the International AAAI Conference on Web and Social Media, 15*(1), 1009-1015. [https://doi.org/10.1609/icwsm.v15i1.18124](https://doi.org/10.1609/icwsm.v15i1.18124)

Meta. (2020a, August 11). *How we review content*. [https://about.fb.com/news/2020/08/how-we-review-content/](https://about.fb.com/news/2020/08/how-we-review-content/)

Meta. (2020b, September 21). *Helping creators and publishers manage their intellectual property*. [https://about.fb.com/news/2020/09/helping-creators-and-publishers-manage-their-intellectual-property/](https://about.fb.com/news/2020/09/helping-creators-and-publishers-manage-their-intellectual-property/)

Meta. (2023, June 29). *Introducing 22 system cards that explain how AI powers experiences on Facebook and Instagram*. [https://ai.meta.com/blog/how-ai-powers-experiences-facebook-instagram-system-cards/](https://ai.meta.com/blog/how-ai-powers-experiences-facebook-instagram-system-cards/)

Trujillo, A., Fagni, T., & Cresci, S. (2025). The DSA Transparency Database: Auditing self-reported moderation actions by social media. *Proceedings of the ACM on Human-Computer Interaction, 9*(2), 1-28. [https://doi.org/10.1145/3711085](https://doi.org/10.1145/3711085)

Twitter, Inc. (2023a, March 31). *A new era of transparency for Twitter*. [https://blog.x.com/en_us/topics/company/2023/a-new-era-of-transparency-for-twitter](https://blog.x.com/en_us/topics/company/2023/a-new-era-of-transparency-for-twitter)

Twitter, Inc. (2023b). *The algorithm* [Computer software]. GitHub. [https://github.com/twitter/the-algorithm](https://github.com/twitter/the-algorithm)

Twitter, Inc. (2023c). *The algorithm ML* [Computer software]. GitHub. [https://github.com/twitter/the-algorithm-ml](https://github.com/twitter/the-algorithm-ml)

Twitter, Inc. (n.d.). *Community Notes* [Computer software]. GitHub. Retrieved July 22, 2026, from [https://github.com/twitter/communitynotes](https://github.com/twitter/communitynotes)

X Corp. (n.d.-a). *About country withheld content*. Retrieved July 22, 2026, from [https://help.x.com/en/rules-and-policies/post-withheld-by-country](https://help.x.com/en/rules-and-policies/post-withheld-by-country)

X Corp. (n.d.-b). *Automated copyright claims for live video*. Retrieved July 22, 2026, from [https://help.x.com/en/rules-and-policies/automated-claims-policy](https://help.x.com/en/rules-and-policies/automated-claims-policy)

X Corp. (2025). *DSA transparency report: April 2025*. [https://transparency.x.com/dsa-transparency-report-2025-april.html](https://transparency.x.com/dsa-transparency-report-2025-april.html)

xAI. (2026). *X algorithm* [Computer software]. GitHub. [https://github.com/xai-org/x-algorithm](https://github.com/xai-org/x-algorithm)

YouTube. (n.d.). *How Content ID works*. Retrieved July 22, 2026, from [https://support.google.com/youtube/answer/2797370](https://support.google.com/youtube/answer/2797370)

YouTube. (2022, December 1). *How we develop and enforce community guidelines and policies at YouTube*. [https://blog.youtube/inside-youtube/policy-development-at-youtube/](https://blog.youtube/inside-youtube/policy-development-at-youtube/)
