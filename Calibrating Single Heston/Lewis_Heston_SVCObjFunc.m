function finalError = Lewis_Heston_SVCObjFunc(marketPrice,bidAskWeights,T,K, u, w, S, r, q, params)
%%
kappa = params(1);
theta = params(2);
sigma = params(3);
v0 = params(4);
rho = params(5);
%%
modelPrice = nan(length(T),length(K));

% Calculate Price for all maturity then strike within that maturity%%
for t=1:length(T)
    for x = 1:length(u) %calc P1 integrand for each maturity at absciccas
        Integrand1(x) = Lewis_HestonCF_P1(u(x), kappa,theta,rho,sigma,T(t),S,r,q,v0);
    end
    for k = 1:length(K) % for each different strike within split tables
        for x = 1:length(u)
            Integrand2(x) = w(x)*Lewis_HestonCF_P2(u(x), T(t),S,K(k),r,q,Integrand1(x));
            %calc P2 integrand using strike and P1 as input
        end
        modelPrice(t,k) = S*exp(-q*T(t)) - (1/pi)*sqrt(K(k)*S)*exp(-(r+q)*T(t)/2)*sum(Integrand2);
    end

end
error = bidAskWeights.*(marketPrice-modelPrice).^2./marketPrice;

finalError = sum(sum(error,"omitnan"))/sum(sum(~isnan(error),2));
