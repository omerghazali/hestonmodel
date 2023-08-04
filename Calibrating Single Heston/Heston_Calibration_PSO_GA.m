
clc;
clear;
%% Initialize Parallel Processing
delete(gcp('nocreate'));
parpool;

%% Settings
path = 'C:\Users\Omer\Desktop\My Matlab Code\Final Folder\Test Data';
filename = 'UnderlyingOptionsEODCalcs_2023-04-03.csv';

useWeights = true;          %If true use weights, equal weighting if false
useESQuadrature = true;     %If true us ES quadrature, GL quadrature if false

%% Load market data
[quoteDate, S,T,K,bidAskWeights,marketPrice,check] = splitRawData(path,filename);
disp(check)                 % Should be 0 if input data is in valid shape

%% Set risk free rate and dividend
r = 0.0477;                 % Risk free rate
q = 0.0;                    % Dividend yield

%% Remove bidAskWeights from obj func if desired
if useWeights == false
    bidAskWeights=ones(size(marketPrice));
end

%% Change quadrature method if desired
if useESQuadrature == false
    [phi32, w32] = GenerateGaussLaguerre(32);
    [phi128, w128] = GaussLaguerre128();
else 
    [phi32, w32] = GenerateExpSinh(32,4.25);
    [phi128, w128] = GenerateExpSinh(128,4.25);
end

% Integration abscissa must be complex for Lewis 2001 price
u32 = phi32 - (1/2)*1i;
u128 = phi128 - (1/2)*1i;
%% set generational/iteration limits for global optimizers and number of time to repeat
genLimits  = [5 10 15 20 25 100];
repeat = 50;                %number of times to repeat each

%% Initial values for kappa,theta,sigma,v0,rho
e = 1e-5;
lb = [e   e  e  e -.999];   % Lower bound on the estimates
ub = [10  5  5  5  .999];   % Upper bound on the estimates

%% Set static options for GA and PS
optionsGA =  optimoptions('ga','UseParallel',true,'MutationFcn',{@mutationadaptfeasible,5,0.8},'CrossoverFraction',0.5,'PopulationSize',100, 'Display','none');
optionsPS = optimoptions('particleswarm','UseParallel',true,'Display','none','SwarmSize',100);
optionsLocal = optimoptions('fmincon','UseParallel',true, 'Display','none');

%% Begin main loop
for rep = 1:repeat
    disp(rep)

    for limit = 1:length(genLimits)
        %% PSO Start
        optionsPS =  optimoptions(optionsPS,"MaxIterations",genLimits(limit));
        localPSStart = tic;
        [PSParams,PSError] = particleswarm(@(params) Lewis_Heston_SVCObjFunc(marketPrice,bidAskWeights,T,K, u32, w32, S, r, q, params),5,lb,ub,optionsPS);

        %% Local from PSO start with higher resolution
        [localPSParams, localPSError] = fmincon(@(params) Lewis_Heston_SVCObjFunc(marketPrice,bidAskWeights,T,K, u128, w128, S, r, q, params),PSParams,[],[],[],[],lb,ub,[],optionsLocal);
        localPSEnd = toc(localPSStart);

        finalParamsLocalPS{rep, limit} = localPSParams; %outcomes for PSO stored in these 3
        finalErrorLocalPS{rep, limit} = localPSError;
        finalTimeLocalPS{rep,limit} = localPSEnd;
        
        %% GA Start
        optionsGA =  optimoptions(optionsGA,'MaxGenerations',genLimits(limit));
        localGAStart = tic;
        [GAParams,GAError] = ga(@(params) Lewis_Heston_SVCObjFunc(marketPrice,bidAskWeights,T,K, u32, w32, S, r, q, params),5,[],[],[],[],lb,ub,[],optionsGA);

        %% Local from GA start with higher resolution
        [localGAParams, localGAError] = fmincon(@(params) Lewis_Heston_SVCObjFunc(marketPrice,bidAskWeights,T,K, u128, w128, S, r, q, params),GAParams,[],[],[],[],lb,ub,[],optionsLocal);
        localGAEnd = toc(localGAStart);

        finalParamsLocalGA{rep, limit} = localGAParams; %outcomes for GA stored in these 3
        finalErrorLocalGA{rep, limit} = localGAError;
        finalTimeLocalGA{rep,limit} = localGAEnd;
    end
end
