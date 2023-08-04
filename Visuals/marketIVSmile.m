path = 'C:\Users\Omer\Desktop\My Matlab Code\Final Folder\Test Data';
filename = 'UnderlyingOptionsEODCalcs_2023-04-03.csv';
[quoteDate, S,T,K,bidAskWeights,marketPrice,check] = splitRawDatav2(path,filename);
r = 0.0477;         % Risk free rate.
q = 0.0;            % Dividend yield

a = .01;
b = 2;
Tol = 1e-5;
MaxIter = 1000;
for t = 1:length(T)
    for k=1:length(K)
        %modelIV(t,k) = BisecBSIV(S,K(k),r,q,T(t),a,b,modelPrice(t,k),Tol,MaxIter);
        marketIV(t,k) = BisecBSIV(S,K(k),r,q,T(t),a,b,marketPrice(t,k),Tol,MaxIter);
        %modelIV_single(t,k) = BisecBSIV(S,K(k),r,q,T(t),a,b,modelPrice_single(t,k),Tol,MaxIter);
    end
end

moneyness = K/S;
marketIV_T1 = marketIV(2,:);
graph=figure;
plot(moneyness,marketIV_T1);
xlim([moneyness(1) moneyness(33)])
fontsize(graph,12,"points");
xlabel('Moneyness, $K/S_T$','Interpreter','Latex')