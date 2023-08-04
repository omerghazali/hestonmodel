function [x, w] = GenerateExpSinh(n, ta)
% Generate abscissas (x) and weights (w) for Exp Sinh integration
% Using Newton Cotes method in transformed integral
% Ideal for integrating from 0 to inf with endpoint singularities
%   n = number of abscissas
%   ta = end points for integration in transformed interval 
%       typically (~4-4.5)

%pre-allocate 
tk = zeros(n,1);
x = zeros(n,1);
w = zeros(n,1);

%equal width of abscissas in transformed function
h = 2*ta/(n-1);

%determine abscissas in transformed function
for k=1:n
    tk(k)= -ta+(k-1)*h;
end

for j=1:n
    %determine x(j) abscissas in original function
    x(j)=exp((pi/2)*sinh(tk(j)));
    %determine w(j) weights in original function
    w(j)=(pi/2)*cosh(tk(j))*exp(pi/2*sinh(tk(j)))*h;
end

