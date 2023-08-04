function y = Lewis2001Integrand_P2(u,tau,S,K,r,q,P1)
%    kappa,theta,rho,sigma,tau,S,K,r,q,v0,Trap)

% Returns the integrand for the formulation in Equation (3.11) of Lewis (2001).
% u = integration variable
% Heston parameters:
%    kappa  = volatility mean reversion speed parameter
%    theta  = volatility mean reversion level parameter
%    rho    = correlation between two Brownian motions
%    sigma  = volatility of variance
%    v0     = initial variance
% Option features.
%    tau = maturity
%    K = strike price
%    S = spot price
%    r = risk free rate
%    q = dividend yield
%    Trap = 1 "Little Trap" formulation 
%           0  Original Heston formulation

% Log of the stock price.
% x = log(S);
% 
% % Heston a and b parameters
% a = kappa*theta;
% b = kappa;
% 
% d = sqrt((rho*sigma*1i*u - b)^2 + sigma^2*(1i*u + u^2));
% g = (b - rho*sigma*1i*u + d) / (b - rho*sigma*1i*u - d);
% 
% if Trap==1
% 	% "Little Heston Trap" formulation
% 	c = 1/g;
% 	D = (b - rho*sigma*1i*u - d)/sigma^2*((1-exp(-d*tau))/(1-c*exp(-d*tau)));
% 	G = (1 - c*exp(-d*tau))/(1-c);
% 	C = (r-q)*1i*u*tau + a/sigma^2*((b - rho*sigma*1i*u - d)*tau - 2*log(G));
% elseif Trap==0
% 	% Original Heston formulation.
% 	G = (1 - g*exp(d*tau))/(1-g);
% 	C = (r-q)*1i*u*tau + a/sigma^2*((b - rho*sigma*1i*u + d)*tau - 2*log(G));
% 	D = (b - rho*sigma*1i*u + d)/sigma^2*((1-exp(d*tau))/(1-g*exp(d*tau)));
% end

% The Heston characteristic function f2 for ln S(T)
%CFlnST = exp(C + D*v0 + 1i*u*x);

% The cf for the Levy process XT
Y = log(S) + (r-q)*tau;
%CFXT = exp(-1i*u*Y)*CFlnST;

% u2 is the real version of u
u2 = u + 1i/2;
W = Y - log(K);

% P1 is the more complicated part and requires tau
%P1 = CFXT/(u2^2 + 1/4);

%P2 is independant of tau and only requires the strike
P2 = exp(1i*u2*W);

% The reorganized integrand in Equation (3.11) of Lewis (2001)
y = real(P1*P2);



