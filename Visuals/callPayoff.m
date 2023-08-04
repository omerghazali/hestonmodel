

strike = 50;
premium = 10;

syms y(x)
y(x) = piecewise(x > strike+premium,-premium,x < strike+premium,(strike)-x);
xvalues = linspace(0,130,2000);
yvalues=y(xvalues);
graph = figure;
xlabel('$S(T)$','Interpreter','Latex');
ylabel('$PnL$','Interpreter','Latex');
plot(xvalues,yvalues);

yline(0);
xline(strike,"Color","r","LineStyle","--")

xlim([0 130])
ylim([-60 70])
xlabel('$S(T)$','Interpreter','latex',FontSize=14);
ylabel('Payoff','Interpreter','latex',FontSize=14);


