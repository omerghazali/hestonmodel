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
T = [1/12];    % Maturities
CFnum = 2;         % Characteristic function #2

% Integration range
phi = [1e-10:.01:20];
%Integrand = zeros(length(phi), length(T));
test = figure;
%% Calculate the 3 integrands

for x = 1:length(phi);
    u = phi(x) - (1/2)*i; %integration variable must be complex
    Integrand(x) = Lewis2001Integrand(u, kappa, theta, lambda, rho, sigma, T,S,K,r,q,v0,trap);
end

for x = 1:length(phi);
    IntegrandHeston(x) = HestonIntegrand(phi(x),kappa,theta,lambda,rho,sigma,T,K,S,r,q,v0,CFnum,trap);
end


%% Plot the 3 integrands
plot(phi,IntegrandHeston,phi,Integrand)
legend('Heston', 'Lewis','AutoUpdate','off')
xline(0);
yline(0);
%fontsize(test,12,"points");
ylim([-0.5 4])
%% Significantly reduced oscillations, no discontinuities in the function