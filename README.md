[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/odds)

🌐 Overview
This repository contains the MATLAB function `odds.m`, which computes the Risk Ratio (RR), Odds Ratio (OR), confidence intervals, Bayesian credibility assessment, association strength (Cramer's V), and statistical power for a 2×2 contingency table.

⭐ Features
- Risk Ratio with confidence interval
- Absolute Risk Reduction (ARR)
- Relative Risk Reduction (RRR)
- Number Needed to Treat (NNT)
- Odds Ratio with confidence interval
- Bayesian Credibility Assessment (Critical Odds Ratio)
- Cramer's V and association strength classification
- Power estimation (asymptotic normal method)
- Sample-size calculation if power < 0.80

🛠️ Installation
1. Download or clone the repository:
   https://github.com/dnafinder/odds
2. Add the folder to your MATLAB path:
   addpath('path_to_folder');

▶️ Usage
Call the function with a 2×2 matrix:
   odds(x)
or with an optional alpha level:
   odds(x, alpha)

🔣 Inputs
- x : 2×2 matrix  
- alpha : significance level (default = 0.05)

📤 Outputs
Displayed on screen:
- RR, ARR, RRR, NNT
- OR + CI
- Association strength (Cramer’s V)
- Bayesian Credibility Assessment
- Power and required sample sizes (if needed)

📘 Interpretation
The function evaluates association between two conditions or exposures.  
A typical 2×2 structure is:

```text
              Cases        Controls
            +-----------+-----------+
Exposed     |     A     |     B     |
            +-----------+-----------+
Unexposed   |     C     |     D     |
            +-----------+-----------+
```

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
