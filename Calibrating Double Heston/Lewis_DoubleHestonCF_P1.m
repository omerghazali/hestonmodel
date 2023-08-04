function P1 = DoubleHestonCF_P1(u,kappa1, theta1, sigma1,v01, rho1, kappa2, theta2, sigma2, v02, rho2,tau,S,r,q)

% Returns the integrand for the risk neutral probabilities P1 and P2.
% u = integration variable
% Heston parameters:
%    kappa  = volatility mean reversion speed parameter
%    theta  = volatility mean reversion level parameter
%    lambda = risk parameter
%    rho    = correlation between two Brownian motions
%    sigma  = volatility of variance
%    v      = initial variance
% Option features.
%    S  = spot price
%    rf = risk free rate
%    trap = 1 "Little Trap" formulation 
%           0  Original Heston formulation

x0 = log(S);

d1 = sqrt((kappa1-rho1*sigma1*1i*u)^2 + sigma1^2*u*(u+1i));
d2 = sqrt((kappa2-rho2*sigma2*1i*u)^2 + sigma2^2*u*(u+1i));
G1 = (kappa1-rho1*sigma1*u*1i-d1) / (kappa1-rho1*sigma1*u*1i+d1);
G2 = (kappa2-rho2*sigma2*u*1i-d2) / (kappa2-rho2*sigma2*u*1i+d2);
B1 = (kappa1-rho1*sigma1*u*1i-d1)*(1-exp(-d1*tau)) / sigma1^2 / (1-G1*exp(-d1*tau));
B2 = (kappa2-rho2*sigma2*u*1i-d2)*(1-exp(-d2*tau)) / sigma2^2 / (1-G2*exp(-d2*tau));
X1 = (1-G1*exp(-d1*tau))/(1-G1);
X2 = (1-G2*exp(-d2*tau))/(1-G2);
A  = (r-q)*u*1i*tau ...
    + kappa1*theta1/sigma1^2*((kappa1-rho1*sigma1*u*1i-d1)*tau - 2*log(X1)) ...
    + kappa2*theta2/sigma2^2*((kappa2-rho2*sigma2*u*1i-d2)*tau - 2*log(X2)) ;


% The characteristic function.
CFlnST = exp(A + B1*v01 + B2*v02 + 1i*u*x0);

Y = log(S)+(r-q)*tau;
CFXT = exp(-1i*u*Y)*CFlnST;

u2 = u + 1i/2;
%W = Y-log(K);

P1 = CFXT/(u2^2+1/4);
%P2 = exp(1i*u2*W);

%y = real(P1*P2);
