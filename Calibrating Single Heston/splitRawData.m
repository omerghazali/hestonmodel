function [quoteDate, S,T,K,bidAskWeight,marketPrice,check] = splitRawData(path,filename)

data  = readtable(append(path,'\',filename));
data.moneyness = (data.strike./data.active_underlying_price_1545);

filter  =  strcmp(data.option_type, 'C') & ... %only calls
           strcmp(data.root,'SPX') & ... %no SPXW
           data.moneyness < 1.1 & data.moneyness > 0.9 & ... %money filter
           days(data.expiration - data.quote_date)/365 < 1.1 & ... %expiry filter
           rem(data.strike,25)==0; %strikes of 25 filter
data = data(filter,:);

dataProc = data;
dataProc.midprice_1545 = (dataProc.bid_1545 + dataProc.ask_1545)/2;
dataProc.spread_1545 = dataProc.ask_1545 - dataProc.bid_1545;
dataProc.spread_normalized_1545 = dataProc.spread_1545./dataProc.midprice_1545;
dataProc.spread_weight = (dataProc.spread_normalized_1545).^-2./sum((dataProc.spread_normalized_1545).^-2)*size(dataProc,1);
dataProc.annualized_maturity = days(dataProc.expiration - dataProc.quote_date)/365;

quoteDate = dataProc{1,2}; %get the quote date from file
S = dataProc{1,19}; %get the current price from file

dataFinal = dataProc(:,[5 36 39 40]);

dataFinal=sortrows(dataFinal,["annualized_maturity","strike"]); %sort by t,k

dataFinal.maturitySplits = findgroups(dataFinal{:,4});
dataFinal.strikeSplits = findgroups(dataFinal{:,1});

K = unique(dataFinal.strike);
T = unique (dataFinal.annualized_maturity);

bidAskWeight = nan(length(T),length(K));
marketPrice = nan(length(T),length(K));

for row = 1:height(dataFinal) % enumerate through rows assigning to matrix
    currentRow = dataFinal(row,:);

    bidAskWeight(currentRow.maturitySplits, currentRow.strikeSplits) ...
    = currentRow.spread_weight;

    marketPrice(currentRow.maturitySplits, currentRow.strikeSplits) ...
    = currentRow.midprice_1545;
end

check = sum(sum(isnan(marketPrice))); %checks to see if strikes/maturities are balanced, will return 0 if good


