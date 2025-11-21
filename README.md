[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/odds)

🌐 Overview
odds.m computes risk ratio (RR), odds ratio (OR) and a rich set of related measures for a 2×2 contingency table. It is designed for classical binary outcome studies (treated vs control, exposed vs unexposed) and produces both a human-readable summary and an optional structured output for further analysis.

⭐ Features
• Risk Ratio (RR) with confidence interval  
• Absolute and Relative Risk Reduction (ARR, RRR)  
• Number Needed to Treat (NNT), when applicable  
• Odds Ratio (OR) with confidence interval  
• Association measures (Phi and Cramer’s V) with qualitative interpretation  
• Bayesian Credibility Assessment and Critical Odds Ratio (COR)  
• Asymptotic power calculation  
• Recommended sample sizes to achieve Power ≈ 0.80 (Sahai & Khurshid, 1996)  
• Optional structured output for programmatic use  

🛠️ Installation
1. Clone the repository:
   git clone https://github.com/dnafinder/odds
2. Add the folder to your MATLAB path:
   addpath('path_to_odds_folder')

▶️ Usage
Basic call (prints results only):
   x = [25 21; 7 27];
   odds(x);

With custom significance level (e.g. 99% CI):
   odds(x, 0.01);

With structured output:
   stats = odds(x);

Typical 2×2 layout:

              Cases        Controls
            +-----------+-----------+
Exposed     |     A     |     B     |
            +-----------+-----------+
Unexposed   |     C     |     D     |
            +-----------+-----------+

Example matrix:
   x = [A B;
        C D];

🔣 Inputs
X:
   2×2 numeric matrix of non-negative integers. Zeros are internally replaced by 0.5 (continuity correction).

ALPHA (optional):
   Scalar in (0,1), significance level for confidence intervals.
   Default: 0.05 (95% confidence).

📤 Outputs
If called without output:
   Results are printed to the command window, including RR, OR, ARR, RRR, NNT (if defined), Cramer’s V, Critical OR, and power/sample size information.

If called with output:
   stats = odds(x, alpha);

   stats.RR              - risk ratio  
   stats.RR_CI           - [lower upper] CI for RR  
   stats.ARR             - absolute risk reduction  
   stats.RRR             - relative risk reduction  
   stats.NNT             - number needed to treat (NaN if ARR = 0)  

   stats.OR              - odds ratio  
   stats.OR_CI           - [lower upper] CI for OR  
   stats.Phi             - association parameter Phi  
   stats.V               - Cramer’s V  
   stats.AssocText       - textual summary of association strength/sign  

   stats.COR             - Critical Odds Ratio  
   stats.Credible        - true if OR vs COR indicates a credible test  

   stats.alpha           - significance level used  
   stats.n1, stats.n2    - observed sample sizes in the two columns  
   stats.Power           - achieved power (NaN if ARR = 0)  
   stats.PowerOK         - true if Power ≥ 0.80  
   stats.n1_recommended  - recommended n1 for Power ≈ 0.80 (NaN if not computed)  
   stats.n2_recommended  - recommended n2 for Power ≈ 0.80 (NaN if not computed)  

📘 Interpretation
• RR and its CI indicate how much the risk changes between exposed and unexposed groups.  
• ARR and RRR quantify the absolute and relative benefit (or harm) of exposure.  
• NNT is the number of patients needed to treat to observe one additional beneficial outcome; it is undefined if ARR = 0.  
• OR and its CI describe the association in terms of odds; if the CI excludes 1, the association is statistically significant.  
• Phi and Cramer’s V give the strength of association; qualitative labels (weak, moderate, strong) help interpretation.  
• The Bayesian Credibility Assessment compares the observed OR to the Critical OR (COR) to judge whether the test is credible at the chosen confidence level.  
• Power and recommended sample sizes help assess whether the current study is adequately powered and how many subjects would be needed to reach Power ≈ 0.80.

📝 Notes
• Zeros in the 2×2 table are automatically replaced with 0.5 to avoid infinite estimates and to apply a continuity correction.  
• The power and sample size formulas are based on a modified asymptotic normal method with continuity correction (Sahai & Khurshid, 1996).  
• If absolute risk reduction is zero, NNT and power/sample size calculations are not meaningful and are skipped.

📚 Citation
Cardillo G. (2007). Odds: compute odds and risk ratio on a 2×2 matrix.  
GitHub: https://github.com/dnafinder/odds

👤 Author
Giuseppe Cardillo  
Email: giuseppe.cardillo.75@gmail.com  
GitHub: https://github.com/dnafinder

⚖️ License
This project is released under the GNU GPL-3.0 license.
