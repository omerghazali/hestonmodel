clc;
clear;

rng(123);
x=0:1:50;
dW = randn(1,50);
dW = [0 dW];

mu0 = zeros(1,51);
mu1 = 0:0.1:5;

bm0 = mu0 + 1.*dW;
bm1 = mu1 + 0.5.*dW;



mu0_Q = 0:-0.2:-10;
bm0_Q = mu0_Q +dW;
bm1_Q = mu0 + 0.5.*dW;



%plot(x,bm0,"b",x,bm1,"k",x,mu0,"--b",x,mu1,"--k");
plot(x,bm0_Q,"b",x,bm1_Q,"k",x,mu0,"--k",x,mu0_Q,"--b");

ylim([-15,15]);