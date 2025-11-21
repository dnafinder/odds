function stats = odds(x,varargin)
%ODDS Risk ratio, odds ratio and related measures for a 2x2 table.
%
%   ODDS(X) computes risk ratio (RR), odds ratio (OR) and several related
%   quantities for a 2×2 contingency table X (with continuity correction
%   for zero cells). Results are printed to the command window.
%
%   STATS = ODDS(X) also returns a structure STATS with the main results.
%
%   ODDS(X, ALPHA) uses the significance level ALPHA for confidence
%   intervals (default: 0.05 → 95% confidence).
%
%   ----------------------------------------------------------------------
%   Description
%   ----------------------------------------------------------------------
%   The input X must be a 2×2 matrix arranged as:
%
%                       Cases        Controls
%                     ________________________
%   Treated (exposed) |   A    |      B      |
%                     |________|_____________|
%   Control (unexp.)  |   C    |      D      |
%                     |________|_____________|
%
%   The function:
%     - Applies a continuity correction (replacing zero cells by 0.5)
%     - Computes:
%         * Risk Ratio (RR) with confidence interval
%         * Absolute Risk Reduction (ARR)
%         * Relative Risk Reduction (RRR)
%         * Number Needed to Treat (NNT), if ARR ≠ 0
%         * Odds Ratio (OR) with confidence interval
%     - If the OR confidence interval does not include 1, it also computes:
%         * Cramer's V and an interpretation of association strength
%         * Bayesian Credibility Assessment with Critical OR (COR)
%     - Computes asymptotic power and (if power < 0.80) recommended sample
%       sizes using a modified asymptotic normal method with continuity
%       correction according to Sahai & Khurshid (1996).
%
%   ----------------------------------------------------------------------
%   Syntax
%   ----------------------------------------------------------------------
%       odds(X)
%       odds(X, ALPHA)
%       STATS = odds(X)
%       STATS = odds(X, ALPHA)
%
%   ----------------------------------------------------------------------
%   Inputs
%   ----------------------------------------------------------------------
%   X      2×2 numeric matrix of non-negative integers:
%          X(i,j) > 0 are counts; zeros are internally set to 0.5.
%
%   ALPHA  (optional) significance level for confidence intervals:
%          0 < ALPHA < 1, default = 0.05.
%
%   ----------------------------------------------------------------------
%   Outputs
%   ----------------------------------------------------------------------
%   When called without output argument, ODDS prints a human-readable
%   summary to the command window.
%
%   When called with one output:
%
%       STATS  structure with fields:
%
%         % Risk ratio side
%         STATS.RR         - risk ratio
%         STATS.RR_CI      - 1×2 vector, confidence interval for RR
%         STATS.ARR        - absolute risk reduction
%         STATS.RRR        - relative risk reduction
%         STATS.NNT        - number needed to treat (NaN if ARR = 0)
%
%         % Odds ratio side
%         STATS.OR         - odds ratio
%         STATS.OR_CI      - 1×2 vector, confidence interval for OR
%         STATS.Phi        - association parameter Phi (NaN if not defined)
%         STATS.V          - Cramer's V (NaN if not defined)
%         STATS.AssocText  - textual description of association (string)
%
%         % Bayesian credibility
%         STATS.COR        - critical odds ratio
%         STATS.Credible   - logical flag (true if test is credible)
%
%         % Power and sample size
%         STATS.alpha      - significance level used
%         STATS.n1         - sample size in exposed/treated group
%         STATS.n2         - sample size in unexposed/control group
%         STATS.Power      - achieved power (NaN if ARR = 0)
%         STATS.PowerOK    - logical flag (true if Power >= 0.80)
%         STATS.n1_recommended - recommended n1 for Power ≈ 0.80 (NaN if not computed)
%         STATS.n2_recommended - recommended n2 for Power ≈ 0.80 (NaN if not computed)
%
%   ----------------------------------------------------------------------
%   Example
%   ----------------------------------------------------------------------
%   % Passive smoking and lung cancer (hypothetical example):
%   %                    Cancer     Controls
%   %                  ______________________
%   %   Exposed       |   25   |    21      |
%   %                 |________|____________|
%   %   Not exposed   |    7   |    27      |
%   %                 |________|____________|
%   %
%   x = [25 21; 7 27];
%   stats = odds(x);
%
%   ----------------------------------------------------------------------
%   Citation
%   ----------------------------------------------------------------------
%   Cardillo G. (2007). Odds: compute odds and risk ratio on a 2×2 matrix.
%   GitHub: https://github.com/dnafinder/odds
%
%   ----------------------------------------------------------------------
%   Author
%   ----------------------------------------------------------------------
%   Author : Giuseppe Cardillo
%   Email  : giuseppe.cardillo.75@gmail.com
%   GitHub : https://github.com/dnafinder
%   Created: 2007-01-01
%   Updated: 2025-11-21
%   Version: 2.0.0
%
%   ----------------------------------------------------------------------
%   License
%   ----------------------------------------------------------------------
%   This code is released under the GNU GPL-3.0 license.
%

%% Input error handling
p = inputParser;
p.FunctionName = 'odds';

addRequired(p,'x',@(v) validateattributes(v,{'numeric'}, ...
    {'real','finite','integer','nonnan','size',[2 2]}, mfilename,'x',1));

addOptional(p,'alpha',0.05, @(v) validateattributes(v,{'numeric'}, ...
    {'scalar','real','finite','nonnan','>',0,'<',1}, mfilename,'alpha',2));

parse(p,x,varargin{:});
x     = p.Results.x;
alpha = p.Results.alpha;
clear p

% Initialize stats struct (in case nargout > 0)
stats = struct('RR',NaN,'RR_CI',[NaN NaN],'ARR',NaN,'RRR',NaN,'NNT',NaN, ...
               'OR',NaN,'OR_CI',[NaN NaN],'Phi',NaN,'V',NaN,'AssocText',"", ...
               'COR',NaN,'Credible',false, ...
               'alpha',alpha,'n1',NaN,'n2',NaN,'Power',NaN,'PowerOK',false, ...
               'n1_recommended',NaN,'n2_recommended',NaN);

% Continuity correction for zero cells
x(x==0) = 0.5;

fprintf('Significance level: %d%%\n', round((1-alpha)*100));
disp(' ')

Za = -realsqrt(2)*erfcinv(2-alpha);  % Z for (1-alpha) CI

% Column sums and probabilities
R = sum(x,1);              % column totals [n1 n2]
p = x(1,:)./R;             % risk in first row (treated) for each column

%% Risk Ratio (RR)
rr   = p(1)/p(2);
rrse = realsqrt(sum(1./x(1,:) - 1./R));        % SE of log(RR)
rrci = exp(reallog(rr) + ([-1 1].*(Za*rrse))); % CI for RR

d   = abs(diff(p));        % absolute risk reduction
rrr = d/p(2);              % relative risk reduction

fprintf('Risk Ratio: %0.4f<%0.4f<%0.4f\n', rrci(1), rr, rrci(2));
if (rrci(1) <= 1) && (rrci(2) >= 1)
    disp('Confidence interval encompasses RR=1. No significant association on RR.');
end

fprintf('Absolute risk reduction: %0.1f%%\n', d*100);
fprintf('Relative risk reduction: %0.1f%%\n', rrr*100);

if d > 0
    nnt = 1/d;
    fprintf('Number Needed to Treat (NNT): %0.2f\n', nnt);
    fprintf(['Around %d patients need to be tested to correctly detect ' ...
             '100 positive tests for the presence of disease\n'], ...
            ceil(100/d));
else
    fprintf('Number Needed to Treat (NNT): undefined (no risk reduction)\n');
end
disp(' ');

% Fill stats (RR side)
stats.RR    = rr;
stats.RR_CI = rrci;
stats.ARR   = d;
stats.RRR   = rrr;
stats.NNT   = (d>0)*1/d + (d==0)*NaN;  % NaN if d==0

%% Odds Ratio (OR)
or   = prod(diag(x))/prod(diag(rot90(x)));   % OR
orse = realsqrt(sum(1./x(:)));               % SE of log(OR)
orci = exp(reallog(or) + ([-1 1].*(Za*orse)));

fprintf('Odds Ratio: %0.4f<%0.4f<%0.4f\n', orci(1), or, orci(2));

% Fill stats (OR side)
stats.OR    = or;
stats.OR_CI = orci;

AssocText = "";
Phi       = NaN;
V         = NaN;
COR       = NaN;
Credible  = false;

if (orci(1) <= 1) && (orci(2) >= 1)
    disp('Confidence interval encompasses OR=1. No significant association on OR.');
else
    % Association metrics (Phi, Cramer's V)
    N   = sum(x(:));
    Phi = (det(x) - N/2) / realsqrt(prod(sum(x,1))*prod(sum(x,2)));
    phi_hat = max(0, Phi^2 - 1/(N-1));
    k_hat   = 2 - 1/(N-1);
    V       = sqrt(phi_hat/(k_hat - 1));
    fprintf('Cramer''s V: %0.4f\n', V);
    
    switch sign(Phi)
        case -1
            txt2 = 'negative association (protective factor)';
        case 1
            txt2 = 'positive association (risk factor)';
        otherwise
            txt2 = 'no association';
    end
    
    Vabs = abs(V);
    if Vabs <= 0.3
        txt1 = 'Weak ';
    elseif Vabs <= 0.7
        txt1 = 'Moderate ';
    else
        txt1 = 'Strong ';
    end
    
    AssocText = [txt1 txt2];
    disp(AssocText);
    disp(' ');
    
    % Bayesian Credibility Assessment
    disp('Bayesian Credibility Assessment');
    orci_log = reallog(orci);
    COR      = exp(-diff(orci_log)^2/(4*realsqrt(prod(orci_log)))); % Critical OR
    
    if or < 1
        fprintf('Critical Odds Ratio: %0.4f\n', COR);
        if or < COR
            Credible = true;
            fprintf('OR<COR. Test is credible at the %d%%\n', round((1-alpha)*100));
        else
            fprintf('OR>=COR. Test is not credible at the %d%%\n', round((1-alpha)*100));
        end
    else
        COR = 1/COR; % corrected COR for OR>1
        fprintf('Critical Odds Ratio: %0.4f\n', COR);
        if or > COR
            Credible = true;
            fprintf('OR>COR. Test is credible at the %d%%\n', round((1-alpha)*100));
        else
            fprintf('OR<=COR. Test is not credible at the %d%%\n', round((1-alpha)*100));
        end
    end
end
disp(' ');

% Fill stats (association / credibility)
stats.Phi       = Phi;
stats.V         = V;
stats.AssocText = string(AssocText);
stats.COR       = COR;
stats.Credible  = Credible;

%% Power and sample size (asymptotic normal method)
stats.n1 = R(1);
stats.n2 = R(2);

if d > 0
    k  = R(2)/R(1);
    q  = 1 - p;
    pm = (p(1) + k*p(2))/(k+1);
    qm = 1 - pm;
    
    Z1_b = (realsqrt(R(1)*d^2) - Za*realsqrt((1+1/k)*pm*qm)) / ...
           realsqrt(p(1)*q(1) + p(2)*q(2)/k);
    pwr  = 0.5*erfc(-Z1_b/realsqrt(2));
    
    fprintf('alpha = %0.4f  n1 = %d  n2 = %d\n', alpha, R(1), R(2));
    fprintf('Z1-b = %0.4f  Power (2-tails) = %0.4f\n', Z1_b, pwr);
    
    stats.Power   = pwr;
    stats.PowerOK = (pwr >= 0.80);
    
    if pwr < 0.8
        % Sample size (modified asymptotic normal method with continuity correction)
        nstar = (Za*realsqrt(pm*qm*(1+1/k)) - ...
                 realsqrt(2)*erfcinv(1.6)*realsqrt(p(1)*q(1) + p(2)*q(2)/k))^2 / d^2;
        n1 = round(nstar/4*(1 + realsqrt(1 + 2*(k+1)/(k*d*nstar)))^2);
        n2 = round(k*n1);
        disp(' ');
        disp('To achieve a recommended Power = 0.80');
        fprintf('n1 = %d (add %d subjects to exposed row)\n', n1, n1 - R(1));
        fprintf('n2 = %d (add %d subjects to not exposed row)\n', n2, n2 - R(2));
        
        stats.n1_recommended = n1;
        stats.n2_recommended = n2;
    end
else
    fprintf('Power analysis skipped: absolute risk reduction is zero.\n');
    stats.Power   = NaN;
    stats.PowerOK = false;
end

% If user does not request output, do not leave stats in workspace
if nargout == 0
    clear stats
end

end
