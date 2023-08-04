clc;clear;

path = 'C:\Users\Omer\Desktop\My Matlab Code\Final Folder\Test Data';
filename = 'UnderlyingOptionsEODCalcs_2023-04-03.csv';
[quoteDate, S,T,K,bidAskWeights,marketPrice,check] = splitRawDatav2(path,filename);

K = K';

bidAskWeights_T1 = bidAskWeights(2,:);
bidAskWeights_T2 = bidAskWeights(5,:);
bidAskWeights_T3 = bidAskWeights(8,:);
bidAskWeights_T4 = bidAskWeights(11,:);
graph = figure;
plot(K,bidAskWeights_T1,K,bidAskWeights_T2,K,bidAskWeights_T3,K,bidAskWeights_T4);

xline(S,"Color","r","LineStyle","--")
legend('46 days','137 days','228 days','320 days','Underlying')
xlim([K(1) K(33)])
fontsize(graph,14,"points");
xlabel('$K$','Interpreter','Latex')