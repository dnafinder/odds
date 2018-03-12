# odds
This function calculates the Risk Ratio and the Odds Ratio (OR) on a 2x2
input matrix. Both ratios are computed with confidence intervals. If
confidence interval of OR doesn't encompass the value OR=1, then the
function computes the Bayesian Credibility Assessment of the test. If the
test is credible, the function calculates the Association Parameter Phi.
The association parameter Phi=sqrt(chisquare/N).
The routine coumputes the Power and, if necessary, the sample sizes needed
to achieve a power=0.80 using a modified asymptotic normal method with
continuity correction as described by Hardeo Sahai and Anwer Khurshid in
Statistics in Medicine, 1996, Vol. 15, Issue 1: 1-21.

Syntax: 	ODDS(X,ALPHA)
     
    Inputs:
          X - 2x2 data matrix composed like this: 
.............................................Cases...Controls
                                             ___________
Treated (or exposed to risk factor)          |  A  |  B  |
                                            |_____|_____|
Placebo (or not exposed to risk factors )    |  C  |  D  |
                                            |_____|_____|
                                               
          ALPHA - Significance level (default=0.05).

    Outputs:
          - Risk Ratio with Confidence interval.
          - Absolute Risk Reduction.
          - Relative Risk Reduction.
          - Odds Ratio wirh Confidence interval
          - Critical Odds Ratio (Bayesian Credibility Assessment)
          - Phi (association parameter)
          - Power and sample sizes calculation

     Example: 
..............................Cancer..Controls
                               ___________
Passive smoke exposed         |  25 |  21 |
                              |_____|_____|
Passive smoke not exposed     |  7  |  27 |
                              |_____|_____|

Data matrix must be x=[25 21; 7 27];

Calling on Matlab the function: odds(x)
answer is:

Significance level: 95%
 
Risk Ratio: 2.1021<2.6398<4.0597
Absolute risk reduction: 33.8%
Relative risk reduction: 62.1%
 
Odds Ratio: 1.6662<4.5918<12.6544
Phi: 0.3149
Moderate positive association (risk factor)
 
Bayesian Credibility Assessment
Critical Odds Ratio: 2.4664
OR>COR. Test is credible at the 95%
 
alpha = 0.0500  n1 = 46  n2 = 34
Z1-b = 1.1924  Power (2-tails) = 0.8834

          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2007) Odds: compute odds and risk ratio on a 2x2 matrix. 
http://www.mathworks.com/matlabcentral/fileexchange/15347
