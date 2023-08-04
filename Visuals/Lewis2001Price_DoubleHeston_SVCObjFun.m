function [modelPrice,error]  = Lewis2001Price_DoubleHeston_SVCObjFun(marketPrice,bidAskWeights,T,K, u, w, S, r, q, params)

%first set of parameters
kappa1 = params(1);
theta1 = params(2);
sigma1 = params(3);
v01    = params(4);
rho1   = params(5);

% Second set of parameters
kappa2 = params(6);
theta2 = params(7);
sigma2 = params(8);
v02    = params(9);
rho2   = params(10);

modelPrice = nan(length(T),length(K));

% Calculate Price for all maturity then strike within that maturity%%
for t=1:length(T)
    for x = 1:length(u) %calc P1 integrand for each maturity at absciccas
        Integrand1(x) = DoubleHestonCF_P1(u(x),kappa1, theta1, sigma1,v01, rho1, kappa2, theta2, sigma2, v02, rho2,T(t),S,r,q);
    end
    for k = 1:length(K) % for each different strike within split tables
        for x = 1:length(u)
            Integrand2(x) = w(x)*DoubleHestonCF_P2(u(x), T(t),S,K(k),r,q,Integrand1(x));
            %calc P2 integrand using strike and P1 as input
        end
        modelPrice(t,k) = S*exp(-q*T(t)) - (1/pi)*sqrt(K(k)*S)*exp(-(r+q)*T(t)/2)*sum(Integrand2);
    end

end
error = bidAskWeights.*(marketPrice-modelPrice).^2./marketPrice;

finalError = sum(sum(error,"omitnan"))/sum(sum(~isnan(error),2));
