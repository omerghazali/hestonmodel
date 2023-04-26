% Demonstrate inverse relationship between integrand decay and maturity

clc; clear;

S = 10;            % Spot price.
K = 7;             % Strike price
r = 0.0;           % Risk free rate.
q = 0.0;           % Dividend yield
kappa  =  5;       % Heston parameter: mean reversion speed.
theta  =  0.07;    % Heston parameter: mean reversion level.
sigma  =  0.9;    % Heston parameter: volatility of vol
rho    = -0.9;     % Heston parameter: correlation
lambda =  0;       % Heston parameter: risk
v0     =  0.07;    % Heston parameter: initial variance.
trap = 1;          % "Little Trap" formulation
T = [1/12 .5 1];    % Maturities
CFnum = 2;         % Characteristic function #2

% Integration range
phi = [1e-10:.01:100];
%Integrand = zeros(length(phi), length(T));

%% Calculate the 3 integrands
for t=1:length(T);
    for x = 1:length(phi);
        u = phi(x) - (1/2)*i; %integration variable must be complex
        Integrand(x,t) = Lewis2001Integrand(u, kappa, theta, lambda, rho, sigma, T(t),S,K,r,q,v0,trap);
    end
end

%% Plot the 3 integrands
plot(phi,Integrand(:,1),'k-',phi,Integrand(:,2),'r-',phi,Integrand(:,3),'b-')
legend('Maturity 1 month', 'Maturity 6 months', 'Maturity 12 months')

%% Significantly reduced oscillations, no discontinuities in the function