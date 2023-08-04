%calculated IV
clc;clear;

path = 'C:\Users\Omer\Desktop\My Matlab Code\Final Folder\Test Data';
filename = 'UnderlyingOptionsEODCalcs_2023-04-03.csv';
[quoteDate, S,T,K,bidAskWeights,marketPrice,check] = splitRawDatav2(path,filename);
r = 0.0477;         % Risk free rate.
q = 0.0;            % Dividend yield

bidAskWeights=ones(size(marketPrice));

params = [0.634249573574717,1.17389102239062e-05,0.272956359993837,0.0151371461400978,-0.998964153603013,14.9973346463628,0.0232928536918204,2.60729769401572,0.00619750840067937,-0.531151346152125];

[x,w] = GenerateExpSinh(128,4.25);
u = x - (1/2)*1i;
[modelPrice,finalError]  = Lewis2001Price_DoubleHeston_SVCObjFun(marketPrice,bidAskWeights,T,K, u, w, S, r, q, params);



%%
params_single = [2.31600578904016,0.0371789548158540,0.508272023820823,0.0278551834251933,-0.735900215444515];
[modelPrice_single,finalError_single]  = Lewis2001Price_SVCObjFuncv4(marketPrice,bidAskWeights,T,K, u, w, S, r, q, params_single);


modelIV=nan(size(modelPrice));
marketIV = nan(size(marketPrice));
modelIV_single = nan(size(modelPrice_single));

a = .01;
b = 2;
Tol = 1e-5;
MaxIter = 1000;
for t = 1:length(T)
    for k=1:length(K)
        modelIV(t,k) = BisecBSIV(S,K(k),r,q,T(t),a,b,modelPrice(t,k),Tol,MaxIter);
        marketIV(t,k) = BisecBSIV(S,K(k),r,q,T(t),a,b,marketPrice(t,k),Tol,MaxIter);
        modelIV_single(t,k) = BisecBSIV(S,K(k),r,q,T(t),a,b,modelPrice_single(t,k),Tol,MaxIter);
    end
end
graph=figure;
marketIV_T0 = marketIV(1,:);
marketIV_T1 = marketIV(2,:);
marketIV_T2 = marketIV(5,:);
marketIV_T3 = marketIV(8,:);
marketIV_T4 = marketIV(11,:);

modelIV_T0 = modelIV(1,:);
modelIV_T1 = modelIV(2,:);
modelIV_T2 = modelIV(5,:);
modelIV_T3 = modelIV(8,:);
modelIV_T4 = modelIV(11,:);

modelIV_single_T0 = modelIV_single(1,:);
modelIV_single_T1 = modelIV_single(2,:);
modelIV_single_T2 = modelIV_single(5,:);
modelIV_single_T3 = modelIV_single(8,:);
modelIV_single_T4 = modelIV_single(11,:);

plot(K,marketIV_T0,"-o",K,modelIV_T0,"-*",K,modelIV_single_T0,"-x");
legend('Market','Double Heston','Heston')
xlim([K(1)-25 K(33)+25])
fontsize(graph,12,"points");
xlabel('$K$','Interpreter','Latex')